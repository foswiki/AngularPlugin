FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-loader.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-loader.js
	@echo getting $@ from git
	@cp $< $@


