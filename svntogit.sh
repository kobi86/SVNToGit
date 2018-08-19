#!/bin/sh

SVNREPO="{Enter SVN REPO URL}"
TFSREPO="{Enter TFS REPO URL}"


git svn init -t tags -b branches -T trunk $SVNREPO
git svn fetch

git remote add origin $TFSREPO

echo Converting tags...
git for-each-ref refs/remotes/origin/tags | cut -d / -f 5- |
while read ref
do
git tag -a "$ref" -m "Essence say farewell to SVN" "refs/remotes/origin/tags/$ref"
git push origin ":refs/heads/tags/$ref"
git push origin tag "$ref"
done

echo Converting branches...
git branch -r | grep -v tags | sed -rne 's, *([^@]+)$,\1,p' | \
while read branch; do \
 echo "git branch $branch $branch"; \
done | sh

echo Compacting Git repository...
git repack -d -f -a --depth=50 --window=100

git push -u origin --all
