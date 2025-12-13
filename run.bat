@echo off
cd ygopro-server/windbot
start WindBot.exe servermode=true serverport=2399
cd ..
start ../node/node.exe ygopro-server.js
