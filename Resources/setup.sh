#!/bin/sh
BIT=${1:-}
OS=`uname -s`
DATE=`date +%Y-%m-%d`
CWD=`pwd`
TMP="$CWD/tmp"
RESOURCES="$CWD/Resources"
PACKAGES="$TMP/packages"
DOMAIN="natron.community.plugins"

BINARY="NCP-${DATE}"
if [ "$OS" != "Linux" ] && [ "$OS" != "Darwin" ]; then
  BINARY="${BINARY}.exe"
  OS="Windows"
fi

PLUGINS="
Filter/Chromatic_Aberation
Time/FrameStamp
"

if [ -d "$TMP" ]; then
  rm -rf "$TMP"
fi
mkdir -p "$PACKAGES" || exit 1

for PLUGINPATH in $PLUGINS; do
  PLUGINNAME=`echo $PLUGINPATH | sed 's@.*/@@'`
  mkdir -p "$PACKAGES"/${DOMAIN}.$PLUGINNAME/{data,meta} || exit 1
  cp "$PLUGINPATH"/${PLUGINNAME}.p* "$PACKAGES"/${DOMAIN}.$PLUGINNAME/data/ || exit 1
  cat "$PLUGINPATH"/${PLUGINNAME}.xml | sed 's/@DATE@/'${DATE}'/' > "$PACKAGES"/${DOMAIN}.$PLUGINNAME/meta/package.xml || exit 1
  cat "$RESOURCES"/package.qs > "$PACKAGES"/${DOMAIN}.$PLUGINNAME/meta/installscript.qs || exit 1
done

if [ -f "$RESOURCES"/${OS}.xml ]; then
  PATH="$RESOURCES"/utils/${OS}${BIT}:$PATH binarycreator -v -f -p "$PACKAGES" -c "$RESOURCES"/${OS}.xml
else
  echo "Setup file don't exist, failed!"
  exit 1
fi
