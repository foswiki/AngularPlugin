FOSWIKI_ROOT?=~/foswiki/core
TARGET=loading-bar.js loading-bar.css

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

loading-bar.uncompressed.js: ../../vendor/bower_components/angular-loading-bar/build/loading-bar.js
	@echo getting $@ from vendor
	@cp $< $@

loading-bar.uncompressed.css: ../../vendor/bower_components/angular-loading-bar/build/loading-bar.css
	@echo getting $@ from vendor
	@cp $< $@

