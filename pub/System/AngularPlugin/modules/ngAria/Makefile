FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-aria.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-aria.uncompressed.js: ../../vendor/angular.js/build/angular-aria.js
	@echo getting $@ from git
	@cp $< $@

