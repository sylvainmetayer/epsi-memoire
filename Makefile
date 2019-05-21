.DEFAULT_GOAL := build

filename=main

build:
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex
	@makeglossaries ${filename}
	@bibtex "${filename}".aux
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

docker-build:
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" makeglossaries ${filename}
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" bibtex "${filename}".aux
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

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

removeComment:
	sed -i 's/\\usepackage\[colorinlistoftodos,french\]{todonotes}/\\usepackage\[colorinlistoftodos,french,disable\]{todonotes}/' packages.tex

wordCount:
	@detex main.tex | wc -w | tr -d [:space:]
	@echo
	@echo or 
	@texcount main.tex -inc -incbib -sum -1 2>/dev/null

build-image:
	docker build -t latex-debian .

push-image: build-image
	docker tag latex-debian sylvainmetayer/latex-debian
	docker push sylvainmetayer/latex-debian

