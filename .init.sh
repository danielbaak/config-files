#!/bin/bash
nohup xterm -e htop > /dev/null &
nohup xterm -e alsamixer > /dev/null &
nohup xterm -e moc > /dev/null &
nohup xterm -e watch -n 3600 todo & #/dev/null  &
nohup xterm -e sudo -s > /dev/null &

