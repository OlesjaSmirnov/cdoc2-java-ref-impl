#!/bin/bash

GIT_BRANCH=$(git branch --show-current)

if [[ "master" != "$GIT_BRANCH" ]]; then
  echo "Not on 'master' branch. You have 5 seconds to abort, before script will continue"
  sleep 5
fi


#if [[ -n $(git cherry -v) ]]; then
#  echo "Detected unpushed commits. Exit"
#  exit 1
#fi
#
#if [[ -n $(git status --porcelain --untracked-files=no) ]]; then
#  echo "Uncommited changes detected. Exit"
#  exit 1
#fi

while getopts "v:" opt; do
  case $opt in
    v)
      echo "Changing parent pom version to: $OPTARG" >&2
      mvn versions:set -DnewVersion="${OPTARG}" -DupdateMatchingVersions=false
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done


# replace module -SNAPSHOT version with release version (non-SNAPSHOT)
mvn versions:set -DremoveSnapshot
# build and install into local maven package repository
mvn install
