#!/bin/sh


PWD=`pwd ${0}`

TRACK=`osascript "$PWD/Sidebar.widget/Playbox.widget/as/Get Current Track.applescript"`;
ARTWORK=`osascript "$PWD/Sidebar.widget/Playbox.widget/as/Get Current Artwork.applescript"`;

find "$PWD/Sidebar.widget/Playbox.widget/as" -name "cover-*" ! -name "$ARTWORK" -exec rm {} \;
# rm -rf ``;
echo $TRACK "~" $ARTWORK