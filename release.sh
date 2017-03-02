#!/bin/sh

set -e
clear

# ASK INFO
echo "---------------------------------------------------------------------"
echo "                  GitHub to WordPress.org RELEASER                   "
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

# Check if version is already released.
if $ROOT_PATH git show-ref --tags | egrep -q "refs/tags/v${VERSION}"
then
	echo "Version already tagged and released.";
	echo ""
	echo "Run sh release.sh again and enter another version.";
	exit 1;
else
	echo ""
	echo "v${VERSION} has not been found released.";
fi

read -p "Enter the WordPress plugin slug: " SVN_REPO_SLUG
clear

echo "Now processing..."

SVN_REPO_URL="https://plugins.svn.wordpress.org"

# Set WordPress.org Plugin URL
SVN_REPO=$SVN_REPO_URL"/"$SVN_REPO_SLUG"/"

# Set temporary SVN folder for WordPress release.
TEMP_SVN_REPO=${SVN_REPO_SLUG}"-svn"

# Delete old SVN cache just incase it was not cleaned before after the last release.
rm -Rf $ROOT_PATH$TEMP_SVN_REPO

# CHECKOUT SVN DIR IF NOT EXISTS
if [[ ! -d $TEMP_SVN_REPO ]];
then
	echo "Checking out WordPress.org plugin repository."
	svn checkout $SVN_REPO $TEMP_SVN_REPO || { echo "Unable to checkout repo."; exit 1; }
fi

read -p "Enter your GitHub username: " GITHUB_USER
clear

read -p "Now enter the repository slug: " GITHUB_REPO_NAME
clear

# Set temporary folder for GitHub release.
TEMP_GITHUB_REPO=${GITHUB_REPO_NAME}"-git"

# Delete old GitHub cache just incase it was not cleaned before after the last release.
rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO

echo "---------------------------------------------------------------------"
echo "Is the line secure?"
echo "---------------------------------------------------------------------"
echo " - y for SSH"
echo " - n for HTTPS"
read -p SECURE_LINE

# Set GitHub Repository URL
if [[ ${SECURE_LINE} = "y" ]]
then
	GIT_REPO="git@github.com:"${GITHUB_USER}"/"${GITHUB_REPO_NAME}".git"
else
	GIT_REPO="https://github.com/"${GITHUB_USER}"/"${GITHUB_REPO_NAME}".git"
fi;

clear

# CLONE GIT DIR
echo "Cloning GIT repository from GitHub"
git clone --progress $GIT_REPO $TEMP_GITHUB_REPO || { echo "Unable to clone repo."; exit 1; }

# MOVE INTO GIT DIR
cd $ROOT_PATH$TEMP_GITHUB_REPO
clear

# LIST BRANCHES
echo "---------------------------------------------------------------------"
read -p "Which remote are we fetching? Default is 'origin'" ORIGIN
echo "---------------------------------------------------------------------"

# IF REMOTE WAS LEFT EMPTY THEN FETCH ORIGIN BY DEFAULT
if [[ -z ${ORIGIN} ]]
then
	git fetch origin
else
	git fetch ${ORIGIN}
fi;

echo "Which branch do you wish to release?"
git branch -r || { echo "Unable to list branches."; exit 1; }
echo ""
read -p ${ORIGIN} "/" BRANCH

# Switch Branch
echo "Switching to branch"
git checkout ${BRANCH} || { echo "Unable to checkout branch."; exit 1; }

echo ""
read -p "Press [ENTER] to deploy branch "${BRANCH}

# REMOVE UNWANTED FILES & FOLDERS
echo "Removing unwanted files"
rm -Rf .git
rm -Rf .github
rm -Rf tests
rm -Rf apigen
rm -f .gitattributes
rm -f .gitignore
rm -f .gitmodules
rm -f .travis.yml
rm -f Gruntfile.js
rm -f package.json
rm -f .jscrsrc
rm -f .jshintrc
rm -f composer.json
rm -f phpunit.xml
rm -f phpunit.xml.dist
rm -f README.md
rm -f .coveralls.yml
rm -f .editorconfig
rm -f .scrutinizer.yml
rm -f apigen.neon
rm -f CHANGELOG.md
rm -f CONTRIBUTING.md
rm -f Theme-Presets.md
rm -f screenshot-*.png
rm -f release.sh

# MOVE INTO SVN DIR
cd "../"$TEMP_SVN_REPO

# UPDATE SVN
echo "Updating SVN"
svn update || { echo "Unable to update SVN."; exit 1; }

# DELETE TRUNK
echo "Replacing trunk"
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
echo "Copying trunk to new tag"
svn copy trunk tags/${VERSION} || { echo "Unable to create tag."; exit 1; }

# DO SVN COMMIT
clear
echo "Showing SVN status"
svn status

# PROMPT USER
echo ""
read -p "Press [ENTER] to commit release "${VERSION}" to WordPress.org AND GitHub"
echo ""

# CREATE THE GITHUB RELEASE
echo "Creating release on GitHub repository."
cd "$GITPATH"

echo "Tagging new version in git"
git tag -a "v${VERSION}" -m "Tagging version v${VERSION}"

echo "Pushing latest commit to origin, with tags"
git push origin master
git push origin master --tags

# DEPLOY
echo ""
echo "Committing to WordPress.org... this may take a while..."
svn commit -m "Releasing "${VERSION}"" || { echo "Unable to commit."; exit 1; }

# REMOVE THE TEMP DIRS
echo "Cleaning Up..."
cd "../"
rm -Rf $ROOT_PATH$TEMP_GITHUB_REPO
rm -Rf $ROOT_PATH$TEMP_SVN_REPO

# DONE
echo "Release Done."
echo ""
read -p "Press [ENTER] to close program."

clear
