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

To use it you must:

1. Host your code on GitHub
2. Already have a WordPress.org SVN repository setup for your plugin.
3. Have both GIT and SVN setup on your machine and available from the command line.

## Getting started

All you have to do is download the script release.sh from this repository and place it in a location of your choosing. Can be run from any location.

## Usage

1. Open up terminal and cd to the directory containing the script.
2. Run: ```sh release.sh```
3. Follow the prompts.

## Final notes

- This will checkout the remote version of your GitHub Repo.
- Committing to WordPress.org can take a while so be patient.
- I have tested this on Mac only.
- Use at your own risk of course :smile:
