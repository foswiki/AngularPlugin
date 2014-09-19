FOSWIKI_ROOT?=~/foswiki/core
SUBDIRS=modules i18n
TARGET=angular.js 

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

.PHONY: vendor

vendor: 
	cd vendor/angular.js && git pull && grunt buildall
	cd vendor && bower update

angular.uncompressed.js: vendor/angular.js/build/angular.js
	@echo getting $@ from git
	@cp $< $@

clean: 
	rm -f $(TARGET) *.gz
