#!/usr/bin/env bash
#
#    shellScript.sh - My script for do something
#
#    Site:       https://github.com/jKy0n
#    Author:     jKyon (John Kennedy Loria Segundo)
#    Maintence:  jKyon
#
# ------------------------------------------------------------------------ #
#    Here will be describle what this script do, with much details =)
#
#    Examples:
#         $ ./shellScript.sh -d 1
#         In this example the script will execute debug level 1.
# ------------------------------------------------------------------------ #
#    History:
#         v1.0 03/10/2022, jKyon:
#              - Created script
#              - Had THIS function
#         v1.1 10/10/2022, jKyon:
#              - Change any parameter
# ------------------------------------------------------------------------ #
#    Tested on:
#         bash 5.1.16
#          zsh 5.9
# ------------------------------------------------------------------------ #
#    Thanks and credits:
#
#         Joãozinho  - Find any bug.
#         Mariazinha - Send suggestion to add any function.
# ------------------------------------------------------------------------ #
#
# -------------------------- Memory Organization -------------------------- #
USE_MASSAGE="
     $(basename $0) - [Options]

          This script do this

          -h   -    Help menu
          -v   -    Version
"

VERSION="v0.1"
# ------------------------------------------------------------------------ #

# ------------------------- Tests and Validations ------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- Functions ------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- Exections ------------------------------- #
while test -n "$1"
do
     case "$1" in
          -h)  echo "$USE_MASSAGE" && exit 0 ;;
          -v)  echo "$VERSION" && exit 0 ;;
     esac
     shift
done
# ------------------------------------------------------------------------ #
