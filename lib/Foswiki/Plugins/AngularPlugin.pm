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
use Foswiki::Meta ();
use Foswiki::Plugins ();
use Foswiki::Plugins::JQueryPlugin();
use Foswiki::Contrib::JsonRpcContrib ();

our $VERSION = '0.00_001';
our $RELEASE = '0.00_001';
our $SHORTDESCRIPTION = 'A framework assisting with creating single-page applications';
our $NO_PREFS_IN_TOPIC = 1;
our $service;

=begin TML

---++ earlyInit()

=cut

sub earlyInitPlugin {

  my $request = Foswiki::Func::getRequestObject();
  my $context = Foswiki::Func::getContext();
  my $session = $Foswiki::Plugins::SESSION;
  my $web = $session->{webName};
  my $topic = $session->{topicName};

  #my $url = $session->{request}->url();
  #$url =~ s/POSTDATA.*$/.../;
  #print STDERR "early init $web.$topic ... url=$url\n";

  # special treatment of view context
  if ($context->{view} || $context->{angular}) {
    my $angular = $request->param("angular");
    my $skin = $request->param('skin');

    # evaluate angular url param
    if (defined $angular) {
      $angular = Foswiki::Func::isTrue($angular);

      # set or clear session value based on "angular" url param
      if ($angular) {
        Foswiki::Func::setSessionValue("angular", 1);
      } else {
        Foswiki::Func::clearSessionValue("angular");
      }
    } 

    # without an "angular" url param evaluate session param and decide whether or not to switch into angular mode
    else {
      $angular = Foswiki::Func::getSessionValue("angular");
    }

    if ($angular) {
      if (_isExcluded($web, $topic)) {

        if ($context->{angular}) {

          # redirect to normal mode 
          my $url = Foswiki::Func::getScriptUrl($web, $topic, 'view');
          #print STDERR "redirecting $web.$topic to normal ... $url\n";
          Foswiki::Func::redirectCgiQuery(undef, $url, 1);
        } 

        return;
      }

      # redirect to angular mode 
      if (!$context->{angular} && !defined($skin)) {
        my $url = Foswiki::Func::getScriptUrl($web, $topic, 'angular');
        #print STDERR "redirecting $web.$topic to angular ... $url\n";
        Foswiki::Func::redirectCgiQuery(undef, $url, 1);
        return;
      }

      # enter angular mode 
      $context->{angular} = 1;
      
      # switch to a neutral place internally unless there's a "skin" url param
      unless (defined $skin) {
        my $web = $Foswiki::cfg{UsersWebName};
        my $topic = "SitePreferences";

        #print STDERR "push context $web.$topic\n";
        Foswiki::Func::pushTopicContext($web, $topic);

      }
    }
  }

  return;
}

sub _isExcluded {
  my ($web, $topic) = @_;

  my $excludePattern = $Foswiki::cfg{AngularPlugin}{Exclude};
  return (defined($excludePattern) && "$web.$topic" =~ /$excludePattern/)?1:0;
}

=begin TML

---++ initPlugin($topic, $web, $user) -> $boolean

=cut

sub initPlugin {
  my ($topic, $web) = @_;

  if (_isExcluded($web, $topic)) {
    #print STDERR "$web.$topic excluded from angular mode\n";
  } else {
    if (Foswiki::Func::getContext()->{angular}) {
      #print STDERR "$web.$topic enters angular mode\n";
      my $skin = getSkin();
      #print STDERR "skin=$skin\n";
      Foswiki::Func::setPreferencesValue("SKIN", $skin);
    }
  }

  # get all modules
  foreach my $moduleName (sort keys %{$Foswiki::cfg{AngularPlugin}{Modules}}) {
    registerModule($moduleName)
      if $Foswiki::cfg{AngularPlugin}{Modules}{$moduleName}{Enabled};
  }

  # register jsonrpc methods
  Foswiki::Contrib::JsonRpcContrib::registerMethod("AngularPlugin", "tmpl", 
    sub {
      my $session = shift;
      return service()->tmpl(@_);
    }
  );

  # macros
  Foswiki::Func::registerTagHandler( 'NGAPP', sub {
    return handleMacro("ngCore", "NGAPP", @_);
  });
  Foswiki::Func::registerTagHandler( 'ENDNGAPP', sub {
    return handleMacro("ngCore", "ENDNGAPP", @_);
  });

  return 1;
}

=begin TML

---++ finishPlugin

undo manipulation of view url path

=cut

sub finishPlugin {
}


=begin TML

---++ handleMacro($session, $moduleName, $macorName, ... ) -> $result

=cut

sub handleMacro {
  my $moduleName = shift;
  my $macroName = shift;
  my $session = shift;

  my $module = getModule($moduleName, $session);
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

=begin TML

---++ service() -> $service

returns the service handler or JSON-RPC 

=cut

sub service {

  unless (defined $service) {
    require Foswiki::Plugins::AngularPlugin::Service;
    $service = Foswiki::Plugins::AngularPlugin::Service->new();
  }

  return $service;
}

=begin TML

---++ dispatch($session) 

entry point to an angularized Foswiki

=cut

sub dispatch {
  my $session = shift;

  Foswiki::Func::writeEvent("angular");

  # flag this session to run in angular mode
  Foswiki::Func::setSessionValue("angular", 1);

  my $tmplData = Foswiki::Func::readTemplate('angular');

  $tmplData = Foswiki::Func::expandCommonVariables($tmplData);
  $tmplData = Foswiki::Func::renderText($tmplData);

  $session->writeCompletePage($tmplData);
}

sub getSkin {

  my $skin = Foswiki::Func::getPreferencesValue("SKIN");

  unless ($skin =~ /\bangular\b/) {
    my @skinPath = split(/\s*,\s*/, $skin);
    my $baseSkin = $skinPath[-1];
    unshift @skinPath, "angular";
    unshift @skinPath, "angular.".$baseSkin;
    $skin = join(", ", @skinPath);
  }

  return $skin;
}

=begin TML

---++ completePageHandler

=cut

sub completePageHandler {
  #my $text = $_[0];

  if (Foswiki::Func::getContext()->{angular}) {

    #print STDERR "angular mode ... rewriting urls\n";

    my $viewUrl = Foswiki::Func::getScriptUrl(undef, undef, 'view');
    my $viewUrlPath = Foswiki::Func::getScriptUrlPath(undef, undef, 'view');
    my $angularUrlPath = Foswiki::Func::getScriptUrlPath(undef, undef, 'angular');
    my $webRegex = $Foswiki::regex{'webNameRegex'};
    my $topicRegex = $Foswiki::regex{'topicNameRegex'};

    $_[0] =~ s/(<a[^>]*href=["'])($viewUrl|$viewUrlPath)\/($webRegex)\/($topicRegex)(.*?["'])/$1._processUrl($2, $angularUrlPath, $3, $4).$5/ge;
  } else {
    #print STDERR "NO angular mode\n";
  }
}

sub _processUrl {
  my ($view, $angular, $web, $topic) = @_;

  return (_isExcluded($web, $topic)?$view:$angular).'/'.$web.'/'.$topic; 
}



1;
