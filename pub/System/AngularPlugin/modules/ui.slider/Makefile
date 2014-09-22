FOSWIKI_ROOT?=~/foswiki/core
TARGET=slider.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

slider.uncompressed.js: ../../vendor/ui-slider/src/slider.js
	@echo getting $@ from vendor
	@cp $< $@

