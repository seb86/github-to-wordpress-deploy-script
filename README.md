# GitHub to WordPress.org Deployment Script

A simple deploy script to push any branch from your GitHub repository to your WordPress.org plugin SVN for a new release.

## 🔔 Overview

Releasing WordPress plugins can be quite a chore so a script that handles all of that for you is very helpful. This allows you to do that.

This script is dummy proof and you do NOT need to configure anything so long as you have setup your GIT and SVN login globally. This is to insure you have write permission. Otherwise you will be asked to login every step of the way a GIT or SVN command runs before it proceeds.

Just run the script and follow the instructions as you go along and your new release will be up in no time.


### Is This Free?

Yes, it's free. But here's what you should _really_ care about:
* Steps are easy to understand.
* Does everything for you.


### What's the Catch?

This is a non-commercial script. As such:

* Development time for it is effectively being donated and is therefore, limited.
* Support inquiries may not be answered in a timely manner.
* Critical issues may not be resolved promptly.

Please understand that this repository is not a place to seek help. Use it to report bugs, propose improvements, or discuss new features.

## ✔️ Features
* Supports HTTPS and SSH connections.
* Specify your remote when fetching from your repository.
* Supports Windows if you have TortoiseSVN installed.


## What does the script do?
This script will pull down your remote GIT and SVN repositories, tag a release using the branch you specify, and commit everything to WordPress.org.

As you run the script it will asks questions at certain points to setup the process of the script such as the ROOT Path of your plugin, your GitHub username, repository slug etc.

When it comes to ask for which version you want to release it checks if it has already been tagged before continuing the rest of the script.

The following file types are removed from the parent directory of the plugin location to keep it clean from any development/repository files that the plugin does not need with the release.

```
* .git
* .github
* .wordpress-org
* tests
* apigen
* node_modules
* src
* .babelrc
* .editorconfig
* .eslintignore
* .eslintrc.json
* .gitattributes
* .gitignore
* .gitmodules
* gulpfile.js
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
* package-lock.json
* .jscrsrc
* .jshintrc
* phpunit.xml
* phpunit.xml.dist
* *.xml (Any other XML files)
* .editorconfig
* apigen.neon
* screenshot-*.jpg
* screenshot-*.png
```

Don't see a file that needs to be removed. Create an issue and let me know which file or folder that needs to be removed.


## ✅ Requirements

To use the script you must:

1. Host your code on GitHub.
2. Already have a WordPress.org SVN repository setup for your plugin.
3. Have both GIT and SVN setup on your machine and available from the command line.


## Usage

1. Open up terminal/command prompt and change to the directory containing the script.
2. Run: ```sh release.sh```
3. Follow the prompts.


## ⭐ Feedback

GitHub to WordPress.org Deployment Script is released freely and openly. Feedback or ideas and approaches to solving limitations in GitHub to WordPress.org Deployment Script is greatly appreciated.


#### 📝 Reporting Issues

If you think you have found a bug in the script, please [open a new issue](https://github.com/seb86/github-to-wordpress-deploy-script/issues/new) and I will do my best to help you out.


## Contribute

If you or your company use GitHub to WordPress.org Deployment Script or appreciate the work I’m doing in open source, please consider supporting me directly so I can continue maintaining it and keep evolving the project. It's pretty clear that software actually costs something, and even though it may be offered freely, somebody is paying the cost.

You'll be helping to ensure I can spend the time not just fixing bugs, adding features, releasing new versions, but also keeping the project afloat. Any contribution you make is a big help and is greatly appreciated.

Please also consider starring ✨ and sharing 👍 the repo! This helps the project getting known and grow with the community. 🙏

If you want to do a one-time donation, you can donate to:
- [My PayPal](https://www.paypal.me/codebreaker)
- [BuyMeACoffee.com](https://www.buymeacoffee.com/sebastien)

Thank you for your support! 🙌


## Final Notes

- This will checkout the remote version of your GitHub repository.
- Committing to WordPress.org can take a while so be patient.
- Use at your own risk of course :smile:

