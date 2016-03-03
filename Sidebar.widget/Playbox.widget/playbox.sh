#!/bin/sh

PWD=`pwd ${0}`

TRACK=`osascript "$PWD/Sidebar.widget/Playbox.widget/as/Get Current Track.applescript"`;
ARTWORK=`osascript "$PWD/Sidebar.widget/Playbox.widget/as/Get Current Artwork.applescript"`;

echo $TRACK "~" $ARTWORK