FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-messages.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-animate.uncompressed.js: ../../vendor/angular.js/build/angular-messages.js
	@echo getting $@ from git
	@cp $< $@


