FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-scenario.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-scenario.js
	@echo getting $@ from vendor
	@cp $< $@


