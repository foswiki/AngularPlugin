FOSWIKI_ROOT?=~/foswiki/core
SUBDIRS=modules
# i18n
#vendor
TARGET=angular.js 

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

ifneq (,$(wildcard vendor))
angular.uncompressed.js: vendor/angular.js/build/angular.js
	@echo getting $@ from git
	@cp $< $@
endif

clean: 
	rm -f $(TARGET) *.gz
