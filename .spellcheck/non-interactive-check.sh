#!/bin/bash

res=$(aspell list --mode=tex -l fr -d fr --add-tex-command="loadglsentries op" --add-tex-command="bibliographystyle op" < "$1")

if [ "$res" == "" ]; then
    echo "No spell check errors. This is a basic check, please double-check !"
    exit 0
fi

echo "Spell check error found. For details, run the interactive script with make spellcheck."
echo "----"
echo "$res"
echo "---"
exit 1
