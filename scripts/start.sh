#!/bin/bash
set -e

# default JVM args
JVM_ARGS=${JVM_ARGS:--Xms1024M -Xmx1024M}

# get latest version
VERSIONS=$(curl -sL https://launchermeta.mojang.com/mc/game/version_manifest.json)
if [ -z "$VERSION" ] || [ "$VERSION" = "latest" ]
then
  VERSION=$(echo "$VERSIONS" | jq -r .latest.release)
fi
if [ "$VERSION" = "latest-snapshot" ]
then
  VERSION=$(echo "$VERSIONS" | jq -r .latest.snapshot)
fi

# download server.jar if it does not exist
if [ ! -e $HOME/jars/server-$VERSION.jar ]
then
  URL=$(echo "$VERSIONS" | jq -r ".versions[] | select(.id == \"$VERSION\") | .url")
  wget -O $HOME/jars/server-$VERSION.jar "$(curl -sL $URL | jq -r .downloads.server.url)"
fi

# move to the server directory
cd $HOME/data

# accept the eula
if [ "$EULA" = "true" ] && ( [ ! -e eula.txt ] || [ -n $(grep "eula=false" eula.txt) ] )
then
  rm -f eula.txt
  echo eula=true > eula.txt
fi

# create the stdin pipe for the server console
rm -f $HOME/run/console
mkfifo $HOME/run/console

# start the server
java $JVM_ARGS -jar $HOME/jars/server-$VERSION.jar nogui < <(tail -f $HOME/run/console)
rm -f rm -f $HOME/run/console
