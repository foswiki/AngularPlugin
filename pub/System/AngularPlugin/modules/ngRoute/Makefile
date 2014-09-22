FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-route.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-route.js
	@echo getting $@ from vendor
	@cp $< $@


