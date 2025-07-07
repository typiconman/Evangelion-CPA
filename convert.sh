#!/bin/bash

# Check if the system is a Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONTFORGE_BIN="/Applications/FontForge.app/Contents/Resources/opt/local/bin/fontforge"
    if [[ ! -x "$FONTFORGE_BIN" ]]; then
        echo "FontForge binary not found in FontForge.app package."
        exit 1
    fi
else
    FONTFORGE_BIN="fontforge"
fi

# First, backup the features.fea file because it has handcoded stuff
cp sources/EvangelionCPA-Regular.ufo/features.fea features.fea.bak

# Run FontForge with the provided arguments
$FONTFORGE_BIN -lang=ff -c 'Open($1); Generate($2)' sources/EvangelionCPA.sfd sources/EvangelionCPA-Regular.ufo

# Dirty hack to add the openTypeOS2Selection key to the fontinfo.plist file
# because FontForge doesn't write this to the file and
# because I'm sick of removing this from the commit staging every time
FONTINFO=`cat sources/EvangelionCPA-Regular.ufo/fontinfo.plist`
echo "${FONTINFO/    <key>openTypeOS2Type<\/key>/    <key>openTypeOS2Selection</key>$'\n'    <array>$'\n'      <integer>7</integer>$'\n'    </array>$'\n'    <key>openTypeOS2Type</key>}" > sources/EvangelionCPA-Regular.ufo/fontinfo.plist
