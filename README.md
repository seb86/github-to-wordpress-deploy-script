# GitHub to WordPress.org Deployment Script
Releasing WordPress plugins can be quite a chore so a script that handles all of that for you is very helpful. This allows you to do that.

This script is dummy proof. No need to configure anything. Just run the script and follow the instructions as you go along.

## Features
* Supports HTTPS and SSH connections.
* Specify your remote when fetching from your repository.

## What does the script do?
This script will pull down your remote GIT and SVN repositories, tag a release using the branch you specify, and commit everything to WordPress.org.

As you run the script it will asks questions at certain points to setup the process of the script such as the ROOT Path of your plugin, your GitHub username, repository slug etc.

When it comes to ask for which version you want to release it checks if it has already been tagged before continuing the rest of the script.

It also removes unwanted files that should not be included with the release.

The following file types are removed from the parent directory of the plugin location.

* .git
* .github
* tests
* apigen
* node_modules
* .gitattributes
* .gitignore
* .gitmodules
* *.md (Any MarkDown file)
* *.rb (Any ruby file)
* *.sh (Any bash scripts)
* *.lock
* .coveralls.yml
* .scrutinizer.yml
* .travis.yml
* *.yml (Any other YML files)
* Gruntfile.js
* composer.json
* package.json
* .jscrsrc
* .jshintrc
* phpunit.xml
* *.xml (Any other XML files)
* phpunit.xml.dist
* .editorconfig
* apigen.neon
* screenshot-*.jpg
* screenshot-*.png

Don't see a file that needs to be removed. Create an issue and let me know which file or folder that needs to be removed.

To use the script you must:

1. Host your code on GitHub.
2. Already have a WordPress.org SVN repository setup for your plugin.
3. Have both GIT and SVN setup on your machine and available from the command line.

## Getting Started

All you have to do is download the script release.sh from this repository and place it in a location of your choosing. Can be run from any location.

## Usage

1. Open up terminal and cd to the directory containing the script.
2. Run: ```sh release.sh```
3. Follow the prompts.

## Final Notes

- This will checkout the remote version of your GitHub Repo.
- Committing to WordPress.org can take a while so be patient.
- I have tested this on Mac only.
- Use at your own risk of course :smile:

### Support Sébastien's Open Source Projects!
If you'd like me to keep producing free and open source software or if you use this script and find it useful then please consider [paying for an hour](https://www.paypal.me/CodeBreaker/100eur) of my time. I'll spend two hours on open source for each contribution.

You can find more of my Free and Open Source scripts on [GitHub](https://github.com/seb86)
