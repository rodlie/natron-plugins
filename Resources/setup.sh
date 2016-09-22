#!/bin/sh
VERSION=1.0beta1
DATE=`date +%Y-%m-%d`
BIT=${1:-}
OS=`uname -s`
CWD=`pwd`
TMP="$CWD/tmp"
RESOURCES="$CWD/Resources"
PACKAGES="$TMP/packages"
DOMAIN="natron.community.plugins"

BINARY="NCP-${VERSION}-${OS}-${BIT}"
if [ "$OS" != "Linux" ] && [ "$OS" != "Darwin" ]; then
  BINARY="${BINARY}.exe"
  OS="Windows"
fi

PLUGINS="
Color/lp_Tweaky
Draw/FrameStamp
Draw/LightWrap_Simple
Draw/ReFlect
Draw/ReShade
Draw/SSAO
Draw/Vignette
Draw/Z2Normal
Filter/Chromatic_Aberration
Filter/ChromaticAberrationPP
Filter/Defocus
Filter/EdgeBlur
Filter/lp_ColourSmear
Filter/lp_Despot
Filter/lp_fakeDefocus
Filter/PM_VectorBlur
Keyer/lp_CleanScreen
Keyer/lp_Despill
Keyer/lp_HairKey
Keyer/lp_SimpleKeyer
Merge/ZCombine
Transform/Shaker
"

if [ -d "$TMP" ]; then
  rm -rf "$TMP"
fi
mkdir -p "$PACKAGES" || exit 1

for PLUGINPATH in $PLUGINS; do
  PLUGINNAME=`echo $PLUGINPATH | sed 's@.*/@@'`
  mkdir -p "$PACKAGES"/${DOMAIN}.$PLUGINNAME/{data,meta} || exit 1
  cp "$PLUGINPATH"/${PLUGINNAME}.p* "$PACKAGES"/${DOMAIN}.$PLUGINNAME/data/ || exit 1
  cat "$PLUGINPATH"/${PLUGINNAME}.xml | sed 's/@DATE@/'${DATE}'/;s#</Package>#<Dependencies>'${DOMAIN}'.core</Dependencies></Package>#' > "$PACKAGES"/${DOMAIN}.$PLUGINNAME/meta/package.xml || exit 1
  cat "$RESOURCES"/package.qs > "$PACKAGES"/${DOMAIN}.$PLUGINNAME/meta/installscript.qs || exit 1
  cp "$CWD"/Licenses/GPL-2.0 "$PACKAGES"/${DOMAIN}.$PLUGINNAME/meta/ || exit 1
  cp "$CWD"/Licenses/CC-BY-2.0 "$PACKAGES"/${DOMAIN}.$PLUGINNAME/meta/ || exit 1
done

mkdir -p "$PACKAGES"/${DOMAIN}.core/{data,meta} || exit 1
cat "$RESOURCES"/core.xml | sed 's/@DATE@/'${DATE}'/' > "$PACKAGES"/${DOMAIN}.core/meta/package.xml || exit 1
cat "$RESOURCES"/package.qs > "$PACKAGES"/${DOMAIN}.core/meta/installscript.qs || exit 1
cp "$CWD"/Licenses/GPL-2.0 "$PACKAGES"/${DOMAIN}.core/meta/ || exit 1
cp "$CWD"/Licenses/CC-BY-2.0 "$PACKAGES"/${DOMAIN}.core/meta/ || exit 1

if [ -f "$RESOURCES"/${OS}.xml ]; then
  PATH="$RESOURCES"/utils/${OS}${BIT}:$PATH binarycreator -v -f -p "$PACKAGES" -c "$RESOURCES"/${OS}.xml "$BINARY"
else
  echo "Setup file don't exist, failed!"
  exit 1
fi
