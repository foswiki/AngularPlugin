FOSWIKI_ROOT?=~/foswiki/core
TARGET=ngFx.js

SOURCES= \
    ../../vendor/ngFx/bower_components/gsap/src/uncompressed/TweenMax.js \
    ../../vendor/ngFx/src/animationsAssist.js \
    ../../vendor/ngFx/src/animationClass.js \
    $(wildcard ../../vendor/ngFx/src/animations/*.js) \
    ../../vendor/ngFx/src/transitionsAssist.js \
    ../../vendor/ngFx/src/transitionsClass.js \
    $(wildcard ../../vendor/ngFx/src/transitions/*.js) \
    $(wildcard ../../vendor/ngFx/src/domAnimations/*.js) \
    $(wildcard ../../vendor/ngFx/src/directives/*.js) \
    ../../vendor/ngFx/src/animate.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

ngFx.uncompressed.js: $(SOURCES)
	@echo getting $@ from vendor
	@cat $^ > $@

