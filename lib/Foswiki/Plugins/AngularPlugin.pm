# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# AngularPlugin is Copyright (C) 2014 Michael Daum http://michaeldaumconsulting.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Plugins::AngularPlugin;

use strict;
use warnings;

=begin TML

---+ package Foswiki::Plugins::AngularPlugin

Container for Angular.JS and modules

=cut


use Foswiki::Func ();
use Foswiki::Plugins::JQueryPlugin();

our $VERSION = '0.00_001';
our $RELEASE = '0.00_001';
our $SHORTDESCRIPTION = 'A framework assisting with creating single-page applications';
our $NO_PREFS_IN_TOPIC = 1;

=begin TML

---++ initPlugin($topic, $web, $user) -> $boolean

=cut

sub initPlugin {

  # get all modules
  foreach my $moduleName (sort keys %{$Foswiki::cfg{AngularPlugin}{Modules}}) {
    registerModule($moduleName)
      if $Foswiki::cfg{AngularPlugin}{Modules}{$moduleName}{Enabled};
  }

  # macros
  Foswiki::Func::registerTagHandler( 'NGAPP', sub {
    return handleMacro("Core", "NGAPP", @_);
  });
  Foswiki::Func::registerTagHandler( 'ENDNGAPP', sub {
    return handleMacro("Core", "ENDNGAPP", @_);
  });

  return 1;
}

=begin TML

---++ handleMacro($session, $moduleName, $macorName, ... ) -> $result

=cut

sub handleMacro {
  my $moduleName = shift;
  my $macroName = shift;
  my $session = shift;

  my $module = getModule("Core", $session);
  return _inlineError("ERROR: can't load $moduleName") unless defined $module;

  my $handler = 'handle'.$macroName;
  my $result;

  if ( $module->can($handler) ) {
    $result = $module->$handler(@_);
  } else {
    $result = _inlineError("ERROR: can't execute handler for macro $macroName");
  }

  return $result;
}

=begin TML

---++ registerModule($moduleName, $class) -> $module

API to register an Angular.JS module. This is of use for other Foswiki plugins
to register their modules. Registering a module 'foobar'
will make it available via =%<nop>JQREQUIRE{"foobar"}%=, similar to normal jQuery plugins.

Class will default to 'Foswiki::Plugins::AngularPlugin::FOOBAR,

The FOOBAR.pm stub must be derived from Foswiki::Plugins::AngularPlugin::Module class.

=cut

sub registerModule {
  my ($moduleName, $class) = @_;

  $class ||= $Foswiki::cfg{AngularPlugin}{Modules}{$moduleName}{Module}
    || 'Foswiki::Plugins::AngularPlugin::' . uc($moduleName);

  return Foswiki::Plugins::JQueryPlugin::registerPlugin($moduleName, $class);
}

=begin TML

---++ getModule($moduleName, ...) -> $module

API to create an Angular.JS module. Instantiating it adds all required javascript
and css files to the html page header.

=cut

sub getModule {
  my $moduleName = shift;

  return Foswiki::Plugins::JQueryPlugin::createPlugin($moduleName);
}

sub _inlineError {
    my $msg = shift;
    return "<div class='foswikiAlert'>$msg</div>";
}


1;
