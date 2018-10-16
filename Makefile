all: http

http: node_modules config.json
http: $(shell find jade -name \*.jade) $(shell find stylus -name \*.styl)
	./build.sh

tidy:
	rm -rf $(shell find . -name \*~ -o -name \#\*)

clean: tidy
	rm -rf http jade/{manual,main,download,gcode}/{template,menu}.jade

publish: http
	rsync -Lav http/ root@camotics.org:/var/www/camotics.org/http/

node_modules:
	npm install
