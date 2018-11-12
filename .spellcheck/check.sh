#!/bin/sh

aspell check --mode=tex -l fr -d fr $1 --add-tex-command="loadglsentries op" --add-tex-command="bibliographystyle op"
