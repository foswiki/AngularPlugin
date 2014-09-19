FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-cookies.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-cookies.js
	@echo getting $@ from git
	@cp $< $@


