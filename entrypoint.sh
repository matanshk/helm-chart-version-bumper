#!/bin/bash

## default mode to bump: patch"
MODE=${INPUT_MODE}
if [ "$1" ]; then
  MODE=$1
fi


## default path: ./Chart.yaml
CHART_YAML=${CHART_FILE}
if [ "$2" ]; then
  CHART_YAML=$2
fi


## Check if file exist
if test -f "$CHART_YAML"; then
  echo "$CHART_YAML found."
else
  echo "File $CHART_YAML not found"
  exit 1
fi


### Chart version ###
CHART_VERSION_ORG_TAG=$(grep "version:" $CHART_YAML | cut -d " " -f 2)
CHART_MAJOR=$(echo $CHART_VERSION_ORG_TAG | cut -d "." -f 1)
CHART_MINOR=$(echo $CHART_VERSION_ORG_TAG | cut -d "." -f 2)
CHART_PATCH=$(echo $CHART_VERSION_ORG_TAG | cut -d "." -f 3)

echo "Original Chrat version is $CHART_VERSION_ORG_TAG"

### App version ###
APP_VERSION_ORG_TAG=$(grep "appVersion:" $CHART_YAML | cut -d " " -f 2)
APP_VERSION_ORG_TAG=${APP_VERSION_ORG_TAG:2:-1}
APP_MAJOR=$(echo $APP_VERSION_ORG_TAG | cut -d "." -f 1)
APP_MINOR=$(echo $APP_VERSION_ORG_TAG | cut -d "." -f 2)
APP_PATCH=$(echo $APP_VERSION_ORG_TAG | cut -d "." -f 3)

echo "Original App version is $APP_VERSION_ORG_TAG"


## version bump calculation
if [ $MODE = "major" ]; then
    CHART_MAJOR=$(expr $CHART_MAJOR + 1)
    APP_MAJOR=$(expr $APP_MAJOR + 1)

elif [ $MODE = "minor" ]; then
    CHART_MINOR=$(expr $CHART_MINOR + 1)
    APP_MINOR=$(expr $APP_MINOR + 1)

elif [ $MODE = "patch" ]; then
    CHART_PATCH=$(expr $CHART_PATCH + 1)
    APP_PATCH=$(expr $APP_PATCH + 1)
fi

## build the new tag version
UPDATED_CHART_VERSION=$CHART_MAJOR.$CHART_MINOR.$CHART_PATCH
UPDATED_APP_VERSION=($APP_MAJOR.$APP_MINOR.$APP_PATCH)

echo "New chart version: $UPDATED_CHART_VERSION"
echo "New app version: $UPDATED_APP_VERSION"


## replace version with the new version without 'v'-prefix
sed -i "s#^version:.*#version: ${UPDATED_CHART_VERSION/v/}#g" "${CHART_YAML}"


## replace appVersion with the version without 'v'-prefix
sed -i "s#^appVersion:.*#appVersion: \"v${UPDATED_APP_VERSION}\"#g" "${CHART_YAML}"


## Set outputs
echo "version=$UPDATED_CHART_VERSION" >> $GITHUB_OUTPUT
echo "appversion=$UPDATED_APP_VERSION" >> $GITHUB_OUTPUT