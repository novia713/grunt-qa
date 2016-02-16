'use strict'
# npm install --save-dev grunt-shell
# npm install --save-dev load-grunt-tasks
# npm install grunt-phpcs --save-dev
# npm install --save-dev grunt-phplint
# npm install grunt-prompt --save-dev
# this script assumes security-checker is in /usr/local/bin
# this script assumes phploc is in /usr/local/bin
# this script assumes pdepend is in /usr/local/bin
# this script assumes php-cs-fixer is in /usr/local/bin

###
@todo: put into variables all the paths for easier customization
@todo: task for checking all the .phar's
###


module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)

  grunt.config.vars = grunt.file.readYAML('variables.yaml')

  grunt.initConfig {

    shell: {
      test_all: {
        command: grunt.config.vars.phpunit_exec + ' --config ' + grunt.config.vars.phpunit_xml
      }
      test_helpers: {
        command: grunt.config.vars.phpunit_exec + ' --config ' + grunt.config.vars.phpunit_xml + ' --testsuite Helpers'
      }
      test_commands: {
        command: grunt.config.vars.phpunit_exec + ' --config ' + grunt.config.vars.phpunit_xml + ' --testsuite Commands'
      }
      phpcs_commands: {
        command: grunt.config.vars.php_cs_exec + ' -a --standard=PSR2  ../Test/Command/*.php'
      }
      phpcs_helpers: {
        command: grunt.config.vars.php_cs_exec + ' --standard=PSR2  ../Test/Helper/*.php'
      }
      phpcsfixer_helpers: {
        command: grunt.config.vars.php_cs_fixer_exec + ' fix ../Test/Helper/*.php --level=psr2 '
      }
      security_checker: {
        command: grunt.config.vars.security_checker_exec + ' security:check ' + grunt.config.vars.root_dir,
        options: {
          stdout: true
        }
      }
      phploc: {
        command: grunt.config.vars.phploc_exec + ' ' + grunt.config.vars.src_dir
      }

      ###
      this creates an xml file in «pdepend» directory
      also creates some JDepend graphics in svg
      ###

      pdepend: {
        command: () ->
          now = grunt.template.today("isoDateTime")
          directory = grunt.config.vars.pdepend_out_dir + now
          mkdir = 'mkdir -p ' + directory
          summary = directory + '/summary.xml'
          chart   = directory + '/chart.svg'
          pyramid = directory + '/pyramid.svg'

          pdepend = pdepend_exec + ' '
          pdepend += '--summary-xml=' + summary + ' '
          pdepend += '--jdepend-chart=' + chart + ' '
          pdepend += '--overview-pyramid=' + pyramid + ' '
          pdepend += grunt.config.vars.src_dir

          return mkdir + ' && ' + pdepend

      }
    }

    phplint: {
      options: {
        swapPath: grunt.config.vars.tmp_dir
      },
      all: [
        grunt.config.vars.root_dir + '/**/*.php'
      ]
    }

    ###
    observa cambios en ficheros para ejecutar tareas
    se puede dar el directorio de ficheros que queramos observar
    se puede dar la tarea cualquiera que queramos ejecutar
    digamos, en este caso, que queremos correr phpcs en cada cambio en los test de Helper
    ###

    watch: {
      scripts: {
        files: '../**/*.php'
        #tasks: ['shell:phpcs_helpers']
        tasks: ['shell:phpcsfixer_helpers']
        options: {

          spawn:false
          event:['all']
        }
      }
    }

    prompt: {
      target: {
        options: {
          questions: [
            {
              config: 'shell.cmd'
              type: 'list'
              message: 'What should i do?'
              default: 'watch'
              choices: [ { name: 'Watch & live linting', value: "watch" }, { name: 'Excute tests over /Helpers', value: "test_helpers" }, { name: 'Excute tests over /Commands', value: "test_commands" }, { name: 'Execute phpcs over /Commands', value:"phpcs_commands" }, { name: 'Execute phpcs over /Helpers', value: "phpcs_helpers"}, { name: 'Php-cs-fixer over /Helpers', value: "phpcsfixer_helpers"}, { name: 'Execute security-checker from SensioLabs', value: 'security_checker'}, { name: 'Execute phploc', value:"phploc" } ]
            }
          ]

          then: (results) ->
            c = grunt.config "shell.cmd"
            if c is "watch"
              cmd = c
            else
              cmd = 'shell:'+ c


            grunt.task.run [ cmd , "prompt:target"]
            console.log ""
        }
      }
    }


  }


  grunt.registerTask 'default', [ 'prompt:target']
