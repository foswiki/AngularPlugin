FOSWIKI_ROOT?=~/foswiki/core
TARGET=angular-localization.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular-localization.uncompressed.js: ../../vendor/bower_components/angular-localization/angular-localization.js
	@echo getting $@ from vendor
	@cp $< $@

