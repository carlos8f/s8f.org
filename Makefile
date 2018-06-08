all:
	@git pull
	@jekyll build
	fix
	@ssh ubuntu@s8f.org -c 'cd s8f.org && git pull'
server:
	@jekyll serve --watch
new:
	@./_scripts/new.sh

