all:
	@git pull
	@jekyll build
new:
	@./_scripts/new.sh

