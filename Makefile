all:
	@git pull
	@jekyll build
server:
	@jekyll serve --watch
new:
	@./_scripts/new.sh

