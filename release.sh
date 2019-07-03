#!/bin/sh

SCRIPT_VERSION="2"

set -e
clear

# ASK INFO
echo "---------------------------------------------------------------------"
echo "           GitHub to WordPress.org Deployment Script v${SCRIPT_VERSION}               "
echo "---------------------------------------------------------------------"
read -p "Enter the ROOT PATH of the plugin you want to release: " ROOT_PATH

if [[ -d $ROOT_PATH ]]; then
	echo "---------------------------------------------------------------------"
	echo "New ROOT PATH has been set."
	cd $ROOT_PATH
elif [[ -f $ROOT_PATH ]]; then
	echo "---------------------------------------------------------------------"
	read -p "$ROOT_PATH is a file. Please enter a ROOT PATH: " ROOT_PATH
fi

echo "---------------------------------------------------------------------"
read -p "Tag and Release Version: " VERSION
echo "---------------------------------------------------------------------"
echo ""
echo "Before continuing, confirm that you have done the following :"
echo ""
read -p " - Added a changelog for v"${VERSION}"?"
read -p " - Set version in the readme.txt and main file to v"${VERSION}"?"
read -p " - Set stable tag in the readme.txt file to v"${VERSION}"?"
read -p " - Updated the POT file?"
read -p " - Committed all changes up to GitHub?"
echo ""
read -p "Press [ENTER] to begin releasing v"${VERSION}
clear

echo "-------------------------------------------------------"
echo "Did you tag a pre-release last?"
read -p "Enter Y for Yes or N for No "${BETA}""
echo "-------------------------------------------------------"
clear

# Check if version is already released.
if ${BETA} = 'n' && $ROOT_PATH git show-ref --tags --exclude-existing | egrep -q "refs/tags/v${VERSION}"; then
	echo "---------------------------------------------------------------------"
	echo "Version already tagged and released.";
	echo "---------------------------------------------------------------------"
	echo "Run this script again and enter another version.";
	echo "---------------------------------------------------------------------"
	exit 1;
else
	echo "---------------------------------------------------------------------"
	echo "Yeah! v${VERSION} is not yet a release.";
	echo "---------------------------------------------------------------------"
fi

read -p "Enter WordPress plugin slug: " SVN_REPO_SLUG
clear

echo "---------------------------------------------------------------------"
echo "Now processing..."
echo "---------------------------------------------------------------------"

SVN_REPO_URL="https://plugins.svn.wordpress.org"

# Set WordPress.org Plugin URL
SVN_REPO=$SVN_REPO_URL"/"$SVN_REPO_SLUG"/"

# Set temporary SVN folder for WordPress release.
TEMP_SVN_REPO=${SVN_REPO_SLUG}"-svn"

# Delete old SVN cache just incase it was not cleaned before after the last release.
rm -Rf $ROOT_PATH$TEMP_SVN_REPO

# CHECKOUT SVN DIR IF NOT EXISTS
if [[ ! -d $TEMP_SVN_REPO ]]; then
	echo "Checking out WordPress.org plugin repository."
	echo "---------------------------------------------------------------------"
	svn checkout $SVN_REPO $TEMP_SVN_REPO || { echo "Unable to checkout repo."; exit 1; }
fi

clear

echo "---------------------------------------------------------------------"
read -p "Enter GitHub username: " GITHUB_USER
echo "---------------------------------------------------------------------"
read -p "Enter repository slug: " GITHUB_REPO_NAME
clear

# Set temporary folder for GitHub release.
TEMP_GITHUB_REPO="prepping-release"

# Delete old GitHub cache just incase it was not cleaned before after the last release.
rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO

echo "---------------------------------------------------------------------"
echo "Is the line secure?"
echo "---------------------------------------------------------------------"
echo " - y for SSH"
echo " - n for HTTPS"
read -p "" SECURE_LINE

# Set GitHub Repository URL
if [[ ${SECURE_LINE} = "y" ]]; then
	GIT_REPO="git@github.com:"${GITHUB_USER}"/"${GITHUB_REPO_NAME}".git"
else
	GIT_REPO="https://github.com/"${GITHUB_USER}"/"${GITHUB_REPO_NAME}".git"
fi;

clear

# CLONE GIT DIR
echo "---------------------------------------------------------------------"
echo "Cloning GIT repository from GitHub"
echo "---------------------------------------------------------------------"
git clone --progress $GIT_REPO $TEMP_GITHUB_REPO || { echo "Unable to clone repo."; exit 1; }

# MOVE INTO GIT DIR
cd $ROOT_PATH$TEMP_GITHUB_REPO
clear

# Which Remote?
echo "---------------------------------------------------------------------"
read -p "Which remote are we fetching? Default is 'origin'" ORIGIN
echo "---------------------------------------------------------------------"

# IF REMOTE WAS LEFT EMPTY THEN FETCH ORIGIN BY DEFAULT
if [[ -z ${ORIGIN} ]]; then
	git fetch origin

	# Set ORIGIN as origin if left blank
	ORIGIN=origin
else
	git fetch ${ORIGIN}
fi;

clear

# List Branches
echo "---------------------------------------------------------------------"
git branch -r || { echo "Unable to list branches."; exit 1; }
echo "---------------------------------------------------------------------"
read -p "Which branch do you wish to release? /" BRANCH

# Switch Branch
echo "---------------------------------------------------------------------"
echo "Switching to branch "${BRANCH}

# IF BRANCH WAS LEFT EMPTY THEN FETCH "master" BY DEFAULT
if [[ -z ${BRANCH} ]]; then
	BRANCH=master
else
	git checkout ${BRANCH} || { echo "Unable to checkout branch."; exit 1; }
fi;

echo "---------------------------------------------------------------------"
read -p "Press [ENTER] to remove unwanted files before release."

# REMOVE UNWANTED FILES & FOLDERS
echo "---------------------------------------------------------------------"
echo "Removing unwanted files..."
echo "---------------------------------------------------------------------"
rm -Rf .git
rm -Rf .github
rm -Rf .wordpress-org
rm -Rf tests
rm -Rf apigen
rm -Rf node_modules
rm -Rf src
rm -Rf sass
rm -Rf scss
rm -Rf assets/sass
rm -Rf assets/scss
rm -Rf .idea/*
rm -f .babelrc
rm -f .editorconfig
rm -f .eslintignore
rm -f .eslintrc.json
rm -f .gitattributes
rm -f .gitignore
rm -f .gitmodules
rm -f gulpfile.js
rm -f .idea
rm -f *.md
rm -f *.rb
rm -f *.sh
rm -f *.lock
rm -f .coveralls.yml
rm -f .scrutinizer.yml
rm -f .travis.yml
rm -f *.yml
rm -f Gruntfile.js
rm -f composer.json
rm -f package.json
rm -f package-lock.json
rm -f .jscrsrc
rm -f .jshintrc
rm -f phpunit.xml
rm -f phpunit.xml.dist
rm -f *.xml
rm -f .editorconfig
rm -f apigen.neon
rm -f screenshot-*.jpg
rm -f screenshot-*.png

clear

echo "---------------------------------------------------------------------"
read -p "READY! Press [ENTER] to deploy branch "${BRANCH}

# MOVE INTO SVN DIR
cd "../"$TEMP_SVN_REPO

# UPDATE SVN
echo "---------------------------------------------------------------------"
echo "Updating SVN"
svn update || { echo "Unable to update SVN."; exit 1; }

# DELETE TRUNK
echo "---------------------------------------------------------------------"
echo "Replacing TRUNK folder."
rm -Rf trunk/

# COPY GIT DIR TO TRUNK
cp -R "../"$TEMP_GITHUB_REPO trunk/

# DO THE ADD ALL NOT KNOWN FILES UNIX COMMAND
svn add --force * --auto-props --parents --depth infinity -q

# DO THE REMOVE ALL DELETED FILES UNIX COMMAND
MISSING_PATHS=$( svn status | sed -e '/^!/!d' -e 's/^!//' )

# iterate over filepaths
for MISSING_PATH in $MISSING_PATHS; do
	svn rm --force "$MISSING_PATH"
done

# COPY TRUNK TO TAGS/$VERSION
echo "---------------------------------------------------------------------"
echo "Copying TRUNK to a new tag"
echo "---------------------------------------------------------------------"
svn copy trunk tags/${VERSION} || { echo "Unable to create tag."; exit 1; }

# DO SVN COMMIT
clear
echo "SVN Status"
svn status

# PROMPT USER
echo "---------------------------------------------------------------------"
read -p "Press [ENTER] to commit release "${VERSION}" to WordPress.org AND GitHub"
echo "---------------------------------------------------------------------"

# CREATE THE GITHUB RELEASE
echo "Creating release on GitHub repository."
cd "$GITPATH"

echo "---------------------------------------------------------------------"
echo "Tagging new version in git"
git tag -a "v${VERSION}" -m "Tagging version v${VERSION}"

echo "---------------------------------------------------------------------"
echo "Pushing latest commit to origin, with tags"
git push origin master
git push origin master --tags

# DEPLOY
echo "---------------------------------------------------------------------"
echo "Committing to WordPress.org... this may take a while..."
svn commit -m "Releasing "${VERSION}"" || { echo "Unable to commit."; exit 1; }

# REMOVE THE TEMP DIRS
echo "---------------------------------------------------------------------"
echo "Cleaning Up..."
echo "---------------------------------------------------------------------"
cd "../"
rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO
rm -Rf $ROOT_PATH$TEMP_SVN_REPO

clear
# DONE
echo "---------------------------------------------------------------------"
echo "Release Done!"
echo "---------------------------------------------------------------------"
read -p "Press [ENTER] to exit program."

clear
