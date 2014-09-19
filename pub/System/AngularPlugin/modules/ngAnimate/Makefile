FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-animate.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-animate.js
	@echo getting $@ from git
	@cp $< $@

