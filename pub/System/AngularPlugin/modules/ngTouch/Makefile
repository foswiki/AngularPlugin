FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-touch.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-touch.js
	@echo getting $@ from vendor
	@cp $< $@


