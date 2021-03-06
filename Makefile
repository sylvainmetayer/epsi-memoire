.DEFAULT_GOAL := help
.PHONY: plantuml soutenance docker-soutenance docker-soutenance-slidesOnly
filename=main

build: clean ## Build the pdf without docker
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex
	@makeglossaries ${filename}
	@biber "${filename}"
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

docker-build: clean ## Build the pdf with docker support
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" makeglossaries ${filename}
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" biber "${filename}"
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

presentation: ## Soutenance presentation
	+$(MAKE) docker-presentation -C soutenance

soutenance: ## Build the presentation
	+$(MAKE) build -C soutenance

docker-soutenance: ## Build the presentation with docker with notes and slides (default)
	+$(MAKE) docker-build -C soutenance

docker-soutenance-slidesOnly: ## Build slides soutenance only
	+$(MAKE) slides -C soutenance
	+$(MAKE) docker-build -C soutenance

version: ## Print latest tag
	@echo -n "Dernière version : "
	@git describe --abbrev=0 --tags

tag: version ## Tag a new version
	@echo "Numéro de version?"; read tag; echo "Message du tag ?"; read message; git tag -a $$tag -m "$$message"; git push; git push --tags

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
	@texcount main.tex -inc -incbib -sum

build-docker-latex: ## Build LaTeX docker image
	docker build -t latex-debian .docker/latex
	docker tag latex-debian sylvainmetayer/latex-debian

build-docker-plantuml: ## Build Plantuml docker image
	docker build -t plantuml .docker/plantuml
	docker tag plantuml sylvainmetayer/plantuml

push-image: build-docker-latex build-docker-plantuml ## Push docker image
	docker push sylvainmetayer/latex-debian
	docker push sylvainmetayer/plantuml

plantuml: build-docker-plantuml ## Generated all plantuml diagram from a docker image
	@docker run -v $$(pwd):/app/data --rm --user="$$(id -u):$$(id -g)" sylvainmetayer/plantuml && rm -rf \?

check: ## Check syntax
	chktex ${filename}.tex

bibliography: ## Check bibliography 
	biber --tool --validate-datamodel -l fr_FR ${filename}.bib

todo: ## Find todo
	@grep -iP "todo" ./content/* *.tex

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
