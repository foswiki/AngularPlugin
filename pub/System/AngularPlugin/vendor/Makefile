REPOS=\
  angular.js \
  ui-slider \
  ngFx \
  angular-loading-bar \
  angular-localization


.PHONY: $(REPOS)

all: $(REPOS)

angular.js: 
	test -d $@ || git clone git@github.com:angular/angular.js.git
	cd $@ && git pull && grunt

ui-slider: 
	test -d $@ || git clone git@github.com:angular-ui/ui-slider.git 
	cd $@ && git pull 

ngFx: 
	test -d ngFx || git clone git@github.com:Hendrixer/ngFx.git
	cd $@ && git pull && bower install

angular-loading-bar:
	bower install $@

angular-localization:
	bower install $@
