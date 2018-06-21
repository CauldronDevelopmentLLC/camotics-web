all: http

http: node_modules $(shell find jade) config.json
	./build.sh

clean:
	rm -rf http jade/{manual,main,download}/{template,menu}.jade

publish: http
	rsync -Lav http/ root@camotics.org:/var/www/camotics.org/http/

node_modules:
	npm install
