#!/usr/bin/env bash
#
echo "" &&
echo "	-----	Desktop 	-----	" &&
doas compsize /home/jkyon/Desktop &&
echo "" &&
echo "	-----	Documents 	-----	" &&
doas compsize /home/jkyon/Documents &&
echo "" &&
echo "	-----	Downloads 	-----	" &&
doas compsize /home/jkyon/Downloads &&
echo "" &&
echo "	-----	Drawing 	-----	" &&
doas compsize /home/jkyon/Drawing &&
echo "" &&
echo "	-----	books 	-----	" &&
doas compsize /home/jkyon/e-books &&
echo "" &&
echo "	-----	Games 	-----	" &&
doas compsize /home/jkyon/Games &&
echo "" &&
echo "	-----	HackintoshShits 	-----	" &&
doas compsize /home/jkyon/HackintoshShits &&
echo "" &&
echo "	-----	ISOs 	-----	" &&
doas compsize /home/jkyon/ISOs &&
echo "" &&
echo "	-----	Music 	-----	" &&
doas compsize /home/jkyon/Music &&
echo "" &&
echo "	-----	Pictures 	-----	" &&
doas compsize /home/jkyon/Pictures &&
echo "" &&
echo "	-----	RapozaTwitch 	-----	" &&
doas compsize /home/jkyon/RapozaTwitch &&
echo "" &&
#echo "	-----	ScriptShell 	-----	" &&
#doas compsize /home/jkyon/ScriptShell &&
echo "" &&
echo "	-----	ToOrganize 	-----	" &&
doas compsize /home/jkyon/ToOrganize &&
echo "" &&
echo "	-----	Videos 	-----	" &&
doas compsize /home/jkyon/Videos &&
echo "" && echo "" &&
echo ""
