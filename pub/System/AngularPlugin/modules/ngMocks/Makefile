FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-mocks.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-mocks.js
	@echo getting $@ from vendor
	@cp $< $@


