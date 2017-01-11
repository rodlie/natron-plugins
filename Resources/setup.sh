#!/bin/sh
VERSION=2.2
DATE=`date +%Y-%m-%d`
BIT=${1:-}
OS=`uname -s`
CWD=`pwd`
TMP="$CWD/tmp"
RESOURCES="$CWD/Resources"
PACKAGES="$TMP/packages"
DOMAIN="natron.community.plugins"
PKG="Natron-Community-Plugins-$VERSION"
BINARY="$PKG-${OS}"
if [ "$OS" != "Linux" ] && [ "$OS" != "Darwin" ]; then
	BINARY="$PKG.exe"
	OS="Windows"
else
	if [ "$OS" = "Linux" ]; then
		BINARY="${BINARY}-$BIT.bin"
	else
		BINARY="$PKG"
	fi
fi

PLUGINS="
Color/lp_Tweaky
Draw/FrameStamp
Draw/LightWrap_Simple
Draw/ReFlect
Draw/ReShade
Draw/Vignette
Draw/Z2Normal
Filter/Chromatic_Aberration
Filter/ChromaticAberrationPP
Filter/Defocus
Filter/lp_ColourSmear
Filter/lp_Despot
Filter/lp_fakeDefocus
Filter/lp_Feather
Filter/lp_roughenEdges
Filter/Orton
Filter/PM_VectorBlur
Keyer/lp_ChillSpill
Keyer/lp_CleanScreen
Keyer/lp_HairKey
Keyer/lp_SimpleKeyer
Merge/ZCombine
Transform/lp_NoiseDistort
Transform/Shaker
Channel/ChannelOffset
Draw/PositionMask
Draw/WaveForm
Filter/DUCK_Alpha_Edge
Filter/DUCK_Denoise
Filter/DUCK_Skin_Cleaner
Filter/DUCK_Smart_Blur
Filter/DePepper
Filter/PxF_Bandpass
Filter/PxF_ChromaBlur
Filter/fxT_Glowy
Keyer/AdditiveKeyer
Keyer/BS_AlphaGrainEdge
Keyer/EdgeMatteDetect
Keyer/IDKeyer
Keyer/PIKDespill
mS/mS_MarkerRemoval_Advanced
mS/mS_RestoreGrain
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
done

mkdir -p "$PACKAGES"/${DOMAIN}.core/{data,meta} || exit 1
cat "$RESOURCES"/core.xml | sed 's/@DATE@/'${DATE}'/' > "$PACKAGES"/${DOMAIN}.core/meta/package.xml || exit 1
cat "$RESOURCES"/package.qs > "$PACKAGES"/${DOMAIN}.core/meta/installscript.qs || exit 1
cp "$CWD"/Licenses/GPL-2.0 "$PACKAGES"/${DOMAIN}.core/meta/ || exit 1
cp "$CWD"/Licenses/CC-BY-2.0 "$PACKAGES"/${DOMAIN}.core/meta/ || exit 1

if [ -f "$RESOURCES"/${OS}.xml ]; then
	PATH="$RESOURCES"/utils/${OS}${BIT}:$PATH binarycreator -v -f -p "$PACKAGES" -c "$RESOURCES"/${OS}.xml "$TMP/$BINARY" || exit 1
else
	echo "Setup file don't exist, failed!"
	exit 1
fi

if [ "$OS" = "Linux" ]; then
	REPO=$CWD/repo
	if [ ! -d "$REPO" ]; then
		mkdir -p "$REPO" || exit 1
	fi
	PATH="$RESOURCES"/utils/${OS}${BIT}:$PATH repogen -v --update-new-components -p "$PACKAGES" -c "$RESOURCES"/${OS}.xml "$REPO"
fi

if [ "$OS" = "Darwin" ]; then
	mkdir -p "$TMP/dmg" || exit 1
	mv "$TMP/$BINARY.app" "$TMP/dmg/" || exit 1
	hdiutil create -volname $PKG -srcfolder "$TMP"/dmg -ov -format UDZO $PKG.dmg || exit 1
else
	mv "$TMP/$BINARY" .
	if [ "$OS" = "Linux" ]; then
		tar cvvzf $BINARY.tgz $BINARY || exit 1
		rm -f $BINARY || true
	fi
fi

