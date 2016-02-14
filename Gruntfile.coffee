'use strict'
# npm install --save-dev grunt-shell
# npm install --save-dev load-grunt-tasks
# npm install grunt-phpcs --save-dev


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
      }
    },

    # observa cambios en ficheros para ejecutar tareas
    # se puede dar el directorio de ficheros que queramos observar
    # se puede dar la tarea cualquiera que queramos ejecutar
    # digamos, en este caso, que queremos correr phpcs en cada cambio en los test de Helper
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
