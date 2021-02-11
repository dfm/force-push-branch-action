#!/bin/sh -l
set -e

# Get the current branch name
CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

# Set to the default if a target branch was not provided
if test -z "${TARGET_BRANCH}"; then
    TARGET_BRANCH="${CURRENT_BRANCH}${BRANCH_SUFFIX}"
    echo "Target branch was not specified; setting it to default: '${TARGET_BRANCH}'"
fi

# Fail if the target and current branch are equal - this is not what we want
if test "${CURRENT_BRANCH}" = "${TARGET_BRANCH}"; then
    echo "The target branch (${TARGET_BRANCH}) matches the current branch (${CURRENT_BRANCH})"
    exit 1
fi

# Set the path to the clone
TARGET_DIRECTORY=$(mktemp -d)
echo $TARGET_DIRECTORY

# Do it.
git clone .git $TARGET_DIRECTORY
cd $TARGET_DIRECTORY
git checkout --orphan ${TARGET_BRANCH}
git rm --cached -rf .
git add -f $1
git -c user.name='gh-actions' -c user.email='gh-actions' commit -m "${COMMIT_MESSAGE}"
git push --force https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY} ${TARGET_BRANCH}
git checkout --force ${CURRENT_BRANCH}
