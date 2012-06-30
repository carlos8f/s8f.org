tags:
	rm -Rf _site/tags/*
	cp tags/index.html tags-index.html
	rm -Rf tags/*
	jekyll
	cp _site/tags/* tags
	mv tags-index.html tags/index.html

.PHONY: tags
