FOSWIKI_ROOT?=~/foswiki/core
TARGET=\
  angular.js \
  angular-animate.js \
  angular-cookies.js \
  angular-loader.js \
  angular-messages.js \
  angular-mocks.js \
  angular-resource.js \
  angular-route.js \
  angular-sanitize.js \
  angular-scenario.js \
  angular-touch.js \

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

angular.uncompressed.js: git/build/angular.js
	@echo getting $@ from git
	@cp $< $@

angular-animate.uncompressed.js: git/build/angular-animate.js
	@echo getting $@ from git
	@cp $< $@

angular-cookies.uncompressed.js: git/build/angular-cookies.js
	@echo getting $@ from git
	@cp $< $@

angular-loader.uncompressed.js: git/build/angular-loader.js
	@echo getting $@ from git
	@cp $< $@

angular-messages.uncompressed.js: git/build/angular-messages.js
	@echo getting $@ from git
	@cp $< $@

angular-mocks.uncompressed.js: git/build/angular-mocks.js
	@echo getting $@ from git
	@cp $< $@

angular-resource.uncompressed.js: git/build/angular-resource.js
	@echo getting $@ from git
	@cp $< $@

angular-route.uncompressed.js: git/build/angular-route.js
	@echo getting $@ from git
	@cp $< $@

angular-sanitize.uncompressed.js: git/build/angular-sanitize.js
	@echo getting $@ from git
	@cp $< $@

angular-scenario.uncompressed.js: git/build/angular-scenario.js
	@echo getting $@ from git
	@cp $< $@

angular-touch.uncompressed.js: git/build/angular-touch.js
	@echo getting $@ from git
	@cp $< $@

clean: 
	rm -f $(TARGET) *.gz
