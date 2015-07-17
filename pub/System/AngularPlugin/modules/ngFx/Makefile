FOSWIKI_ROOT?=~/foswiki/core
TARGET=ngFx.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

ngFx.uncompressed.js: ../../vendor/ngFx/dist/ngFx.js
	@echo getting $@ from vendor
	@cat $^ > $@

