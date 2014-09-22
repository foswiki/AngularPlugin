angular.module('ui.knob', [])
  .directive('knob', function() {
    return {
      restrict: 'EACM',
      template: function(elem, attrs) {

        return '<input value="{{ knob }}">';

      },
      replace: true,
      require: 'ngModel',
      link: function(scope, elem, attrs, ngModel) {

        var opts = {};

        if (!angular.isUndefined(attrs.max)) {
          opts.max = attrs.max;
        }

        if (!angular.isUndefined(attrs.fgColor)) {
          opts.fgColor = attrs.fgColor;
        }

        opts.change = function(value) {
          scope.$apply(function() {
            ngModel.$setViewValue(value);
          });
        }

        elem.knob(opts);

        ngModel.$render = function() {
          elem.val(ngModel.$viewValue).trigger("change");
        };
      }
    };
  });
