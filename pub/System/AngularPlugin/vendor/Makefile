.PHONY: init.angular.js init.ui-slider

all: angular.js ui-slider

init.angular.js:
	@test -d angular.js || git clone git@github.com:angular/angular.js.git

angular.js: init.angular.js
	cd angular.js && git pull && grunt buildall

init.ui-slider:
	@test -d ui-slider || git clone git@github.com:angular-ui/ui-slider.git 

ui-slider: init.ui-slider
	cd ui-slider && git pull 

