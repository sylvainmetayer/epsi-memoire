.DEFAULT_GOAL := help
filename=main

pympress-deps-debian: ## Debian install of pympress
	sudo apt-get install python3 python3-pip libgtk-3-0 libpoppler-glib8 libcairo2 python3-gi python3-cairo python3-gi-cairo gir1.2-gtk-3.0 gir1.2-poppler-0.18
	sudo pip3 install pympress

presentation: build ## Run présentation mode
	pympress main.pdf
	
build: clean ## Build the presentation without docker
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	@lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

docker-build: clean ## Build the presentation with docker support
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd)/../img:/img -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex 
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd)/../img:/img -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex > /dev/null
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v $$(pwd)/../img:/img -v $$(pwd):/data "sylvainmetayer/latex-debian" lualatex --shell-escape -synctex=1 -interaction=nonstopmode -halt-on-error ${filename}.tex

clean: ## Remove everything. Used in TravisCI
	rm -f ${filename}.pdf
	rm -f ${filename}.{ps,log,aux,out,dvi,bbl,blg,glg,glo,gls,ist,lof,lol,lot,synctex.gz,tdo,toc,bcf,run.xml,aux.bbl,aux.blg,bib.blg,nav,snm} ${filename}-blx.bib

todo: ## Find todo
	@grep -iP "todo" ./slides/* *.tex

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

notes:
	sed -i 's/\\setbeameroption{show notes on second screen=right}/%\\setbeameroption{show notes on second screen=right}/' main.tex
	sed -i 's/%\\setbeameroption{show only notes}/\\setbeameroption{show only notes}/' main.tex

slidesOnly:
	sed -i 's/\\setbeameroption{hide notes}/%\\setbeameroption{hide notes}/' main.tex
	sed -i 's/\\setbeameroption{show only notes}/%\\setbeameroption{show only notes}/' main.tex
