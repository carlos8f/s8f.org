all:
	@git pull
	@jekyll _site
server:
	@jekyll serve --watch
new:
	@./_scripts/new.sh

