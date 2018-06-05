all:
	@git pull
	@jekyll build
	fix
server:
	@jekyll serve --watch
new:
	@./_scripts/new.sh

