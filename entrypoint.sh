#!/bin/sh -l

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
if test "${CURRENT_BRANCH}" = "${TARGET_BRANCH}"; then
    echo "The target branch (${TARGET_BRANCH}) matches the current branch (${CURRENT_BRANCH})"
    exit 1
fi
if test -z "${TARGET_BRANCH}"; then
    TARGET_BRANCH="${CURRENT_BRANCH}-actions"
    echo "Target branch was not specified; setting it to default: '${TARGET_BRANCH}'"
fi
git checkout --orphan ${TARGET_BRANCH}
git rm --cached -rf .
git add -f $1
git -c user.name='gh-actions' -c user.email='gh-actions' commit -m "${COMMIT_MESSAGE}"
git push --force https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY} ${TARGET_BRANCH}
