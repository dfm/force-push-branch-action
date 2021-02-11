#!/bin/sh -l

git checkout --orphan ${TARGET_BRANCH}
git rm --cached -rf .
git add -f $1
git -c user.name='gh-actions' -c user.email='gh-actions' commit -m "${COMMIT_MESSAGE}"
git push --force https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY} ${TARGET_BRANCH}
