# :sparkles: :collision: grunt-qa
##Grunt tasks as a quality tool for DrupalConsole development

### Install & Play
#### Install
Create a new directory under the root directory of DrupalConsole. Clone this repo in the new directory. Its parent directory must be the root of DrupalConsole.
#### Play
The only file you need to modify is `Gruntfile.coffee`
You should compile Gruntfile.coffee after modifying it with `coffee -c Gruntfile.coffee`

### Tests & Code Standards
This experiment was born as a creativity flare to explore the options Grunt offers at auditing PHP code quality of the DrupalConsole project.
Initially, my first priorities were to be able to run phpunit tests of the DrupalConsole project. Also live observing code standards when editing files of this project.

This project is totally subject to changes and ideas anyone can propose them.

So far, actual working commands are
 -  `grunt shell:test_all` executes al DrupalConsole tests
 -  `grunt shell:test_commands`  executes all the tests living in /Test/Command
 -  `grunt shell:test_helpers`   executes all the tests living in /Test/Helper
 -  `grunt shell:phpcs_commands` runs phpcs in /Test/Command
 -  `grunt shell:phpcs_helpers`  runs phpcs in /Test/Helper
 
NOTE: to run tests this project assumes that the phpunit.xml.dist has appropiate tests suites following this example (helpers testsuite):
```
<testsuite name="Commands">
 <directory suffix="Test.php">Test/Command</directory>
</testsuite>
```
[you 'll need at least two like this, one for Command and another for Helper]


### Live watching changes and getting notified of coding standards
- you can personalize de *watch* task with whatever command you want, for now i setted up phpcs_helpers to be executed at any change on every /Test/Helper/*.php file. The command to accomplish this is `grunt watch`

### Security Checker & PHPLint
- `grunt phplint` at the moment, lints all the PHP files
- `grunt shell:security_checker` runs comprobations against nasty libraries (it seeks the composer.lock)
 
## Feedback wanted
If you develop DrupalConsole, please let me know how to get better this and feel free to propose any idea or suggestion.
My goal is to make DrupalConsole easier & more confortable to develop

If you want to give this a try, remember you can customize any task simply modifying the routes at Grunfile.coffee :innocent:

