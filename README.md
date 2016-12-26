# Github to WordPress.org Deployment Script
Releasing plugins can be quite a chore for me so after some research I found release scripts that other developers were using to deploy their plugin releases without the fuss. I tried a few and the best one was done by [@MikeJolley](https://github.com/mikejolley/github-to-wordpress-deploy-script), however it did not seem to work 100% for me so I experimented and wrote a version that does it a little bit different.

This script is dummy proof. No need to configure anything. Just run the script and follow the instructions as you go along.

## What does the script do?
This script will pull down your remote GIT and SVN repositories, tag a release using the branch you specify, and commit everything to WordPress.org.

Before or that it asks a few questions to setup the process of the script such as the ROOT Path of the plugin your GitHub username, repository slug and so on.

When it comes to ask for which version you want to release it checks if it has already been tagged before continuing the rest of the script.

To use it you must:

1. Host your code on GitHub
2. Already have a WordPress.org SVN repository setup for your plugin.
3. Have both GIT and SVN setup on your machine and available from the command line.

## Getting started

All you have to do is download the script release.sh from this repository and place it in a location of your choosing.

## Usage

1. Open up terminal and cd to the directory containing the script.
2. Run: ```sh release.sh```
3. Follow the prompts.

## Final notes

- This will checkout the remote version of your Github Repo.
- Committing to WordPress.org can take a while so be patient.
- I have tested this on Mac only.
- Use at your own risk of course :)
