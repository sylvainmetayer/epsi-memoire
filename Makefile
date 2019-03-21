.DEFAULT_GOAL := build

filename=main
pdfname=M19_SYLVAINMETAYER

build:
	lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex
	makeglossaries ${filename}
	bibtex "${filename}".aux
	lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex
	lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex
	cp ${filename}.pdf ${pdfname}.pdf

clean: soft_clean
	rm -f ${pdfname}.pdf

soft_clean: # Remove everything but keep the PDF. Used in TravisCI
	rm -f ${filename}.{ps,log,aux,out,dvi,bbl,blg,glg,glo,gls,ist,lof,lol,lot,synctex.gz,tdo,toc}

spellcheck:
	./.spellcheck/check.sh main.tex

ci-spellcheck:
	./.spellcheck/non-interactive-check.sh main.tex
