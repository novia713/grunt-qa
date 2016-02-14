// Generated by CoffeeScript 1.10.0
(function() {
  'use strict';
  module.exports = function(grunt) {
    require('load-grunt-tasks')(grunt);
    grunt.initConfig({
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

        /*
        this creates an xml file in «pdepend» directory
        also creates some JDepend graphics in svg
         */
        pdepend: {
          command: function() {
            var chart, directory, mkdir, now, pdepend, pyramid, summary;
            now = grunt.template.today("isoDateTime");
            directory = './pdepend/' + now;
            mkdir = 'mkdir -p ' + directory;
            summary = directory + '/summary.xml';
            chart = directory + '/chart.svg';
            pyramid = directory + '/pyramid.svg';
            pdepend = '/usr/local/bin/pdepend ';
            pdepend += '--summary-xml=' + summary + ' ';
            pdepend += '--jdepend-chart=' + chart + ' ';
            pdepend += '--overview-pyramid=' + pyramid + ' ';
            pdepend += '../src';
            return mkdir + ' && ' + pdepend;
          }
        }
      },
      phplint: {
        options: {
          swapPath: '/tmp'
        },
        all: ['../**/*.php']
      },
      watch: {
        scripts: {
          files: '../Test/Helper/*.php',
          tasks: ['shell:phpcs_helpers'],
          options: {
            spawn: false,
            event: ['all']
          }
        }
      }
    });
    return grunt.registerTask('default', ['shell']);
  };

}).call(this);
