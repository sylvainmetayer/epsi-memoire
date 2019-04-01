.DEFAULT_GOAL := build

filename=main

build:
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	makeglossaries ${filename}
	bibtex "${filename}".aux
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

version:
	@echo -n "Dernière version : "
	@git describe --abbrev=0 --tags

tag: version
	@echo "Numéro de version?"; read tag; echo "Message du tag ?"; read message; git tag -a $$tag -m "$$message"; git push --tags

clean: soft_clean
	rm -f ${filename}.pdf

soft_clean: # Remove everything but keep the PDF. Used in TravisCI
	rm -f ${filename}.{ps,log,aux,out,dvi,bbl,blg,glg,glo,gls,ist,lof,lol,lot,synctex.gz,tdo,toc}

paper:
	sed -i 's/% \\toggletrue{paper}/\\toggletrue{paper}/' parameters.tex
	sed -i 's/\\togglefalse{paper}/% \\togglefalse{paper}/' parameters.tex
	grep "toggle" parameters.tex

computer:
	sed -i 's/\\toggletrue{paper}/% \\toggletrue{paper}/' parameters.tex
	sed -i 's/% \\togglefalse{paper}/\\togglefalse{paper}/' parameters.tex
