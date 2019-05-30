.DEFAULT_GOAL := help
.PHONY: plantuml
filename=main

build: ## Build the pdf without docker
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	@makeglossaries ${filename}
	@biber "${filename}"
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

docker-build: ## Build the pdf with docker support
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" makeglossaries ${filename}
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" biber "${filename}"
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

version: ## Print latest tag
	@echo -n "Dernière version : "
	@git describe --abbrev=0 --tags

tag: version ## Tag a new version
	@echo "Numéro de version?"; read tag; echo "Message du tag ?"; read message; git tag -a $$tag -m "$$message"; git push --tags

clean: soft_clean ## Clean all files, including generated pdf
	@rm -f ${filename}.pdf

soft_clean: ## Remove everything but keep the PDF. Used in TravisCI
	@rm -f ${filename}.{ps,log,aux,out,dvi,bbl,blg,glg,glo,gls,ist,lof,lol,lot,synctex.gz,tdo,toc,bcf,run.xml,aux.bbl,aux.blg,bib.blg} ${filename}-blx.bib
	@rm -rf ?/

paper: ## Configuration to enable paper mode
	sed -i 's/% \\toggletrue{paper}/\\toggletrue{paper}/' parameters.tex
	sed -i 's/\\togglefalse{paper}/% \\togglefalse{paper}/' parameters.tex

removeComment: ## Configuration to disable todos
	sed -i 's/\\usepackage\[colorinlistoftodos,french\]{todonotes}/\\usepackage\[colorinlistoftodos,french,disable\]{todonotes}/' packages.tex

wordCount: ## Count the number of words
	@detex main.tex | wc -w | tr -d [:space:]
	@echo
	@echo or 
	@texcount main.tex -inc -incbib -sum -1 2>/dev/null

build-image: ## Build docker image
	docker build -t latex-debian .

push-image: build-image ## Push docker image
	docker tag latex-debian sylvainmetayer/latex-debian
	docker push sylvainmetayer/latex-debian

plantuml: ## Generated all plantuml diagram
	@docker run -v $$(pwd):/usr/src/myapp -w /usr/src/myapp --rm --user="$$(id -u):$$(id -g)" openjdk:13 java -jar plantuml/plantuml.1.2019.6.jar "./plantuml" -o ../img/

check: ## Check syntax
	chktex ${filename}.tex

bibliography: ## Check bibliography 
	biber --tool --validate-datamodel -l fr_FR ${filename}.bib

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
