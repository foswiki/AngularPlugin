FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-sanitize.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-sanitize.js
	@echo getting $@ from git
	@cp $< $@


