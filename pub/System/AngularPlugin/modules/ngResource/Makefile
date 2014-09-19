FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-resource.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-resource.js
	@echo getting $@ from git
	@cp $< $@


