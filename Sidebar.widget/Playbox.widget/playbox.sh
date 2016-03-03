#!/bin/sh

PWD=`pwd ${0}`
# ARTWORK='default.png'

# how do I run the applescripts in the background?

TRACK=`osascript "$PWD/Sidebar.widget/Playbox.widget/as/Get Current Track.applescript"`;
ARTWORK=`osascript "$PWD/Sidebar.widget/Playbox.widget/as/Get Current Artwork.applescript"`

echo $TRACK "~" $ARTWORK