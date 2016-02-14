'use strict'
# npm install --save-dev grunt-shell
# npm install --save-dev load-grunt-tasks
# npm install grunt-phpcs --save-dev
# npm install --save-dev grunt-phplint
# this script assumes security-checker is in /usr/local/bin
# this script assumes phploc is in /usr/local/bin
# this script assumes pdepend is in /usr/local/bin

###
@todo: put into variables all the paths for easier customization
###


module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)

  grunt.initConfig {

    shell: {
      test_all: {
        command: 'phpunit --config ../phpunit.xml.dist'
      },
      test_helpers: {
        command: 'phpunit --config ../phpunit.xml.dist --testsuite Helpers'
      },
      test_commands: {
        command: 'phpunit --config ../phpunit.xml.dist --testsuite Commands'
      },
      phpcs_commands: {
        command: 'phpcs -a --standard=PEAR  ../Test/Command/*.php'
      },
      phpcs_helpers: {
        command: 'phpcs --standard=PEAR  ../Test/Helper/*.php'
      },
      security_checker: {
        command: 'security-checker security:check ..',
        options: {
          stdout: true
        }
      },
      phploc: {
        command: '/usr/local/bin/phploc ../src'
      },
      ###
      this creates an xml file in «pdepend» directory
      also creates some JDepend graphics in svg
      ###
      pdepend: {
        command: () ->
          now = grunt.template.today("isoDateTime")
          directory = './pdepend/' + now
          mkdir = 'mkdir -p ' + directory
          summary = directory + '/summary.xml'
          chart   = directory + '/chart.svg'
          pyramid = directory + '/pyramid.svg'

          pdepend = '/usr/local/bin/pdepend '
          pdepend += '--summary-xml=' + summary + ' '
          pdepend += '--jdepend-chart=' + chart + ' '
          pdepend += '--overview-pyramid=' + pyramid + ' '
          pdepend += '../src'

          return mkdir + ' && ' + pdepend

      }
    },

    phplint: {
      options: {
        swapPath: '/tmp'
      },
      all: [
        '../**/*.php'
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
        files: '../Test/Helper/*.php'
        tasks: ['shell:phpcs_helpers']
        options: {

          spawn:false
          event:['all']
        },
      },
    },
  }

  grunt.registerTask('default', ['shell'])
