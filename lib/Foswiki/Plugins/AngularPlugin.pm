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
  my $angular = $request->param("angular");

  if (defined $angular) {
    if (Foswiki::Func::isTrue($angular)) {
      Foswiki::Func::setSessionValue("angular", 1);
      $context->{angular} = 1;
    } else {
      Foswiki::Func::clearSessionValue("angular");
      $context->{angular} = 0;
    }
  } else {
    if (!_isExcluded($web, $topic)) {
      $context->{angular} = Foswiki::Func::getSessionValue("angular");
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
      my $skin = _getSkin();
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

sub _getSkin {

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

---++ completePageHandler

=cut

sub completePageHandler {
  #my $text = $_[0];

  if (Foswiki::Func::getContext()->{angular}) {

    #print STDERR "angular mode ... rewriting exclude urls\n";

    my $viewUrl = Foswiki::Func::getScriptUrl(undef, undef, 'view');
    my $viewUrlPath = Foswiki::Func::getScriptUrlPath(undef, undef, 'view');
    my $webRegex = $Foswiki::regex{'webNameRegex'};
    my $topicRegex = '\w+'; # support non-wikiword topics as well ... so not using $Foswiki::regex{'topicNameRegex'} here

    $_[0] =~ s/(<a\s+)([^>]*href=["'])($viewUrl|$viewUrlPath)\/($webRegex)\/($topicRegex)(.*?>)/_processUrl($1, $2, $3, $4, $5, $6)/ge;
  }
}

sub _processUrl {
  my ($a, $prefix, $url, $web, $topic, $postfix) = @_;

  my $target = '';
  $target = "target='_self' " if _isExcluded($web, $topic);

  if ($prefix =~ /target=["'][^"']["']/ || $postfix =~ /target=["'][^"']["']/) {
    $target = '';
  }

  my $result = $a.$target.$prefix.$url.'/'.$web.'/'.$topic.$postfix;
  
  #print STDERR "rewriting url to $result\n" if $target;
  #print STDERR "not rewriting url for $web.$topic\n" unless $target;

  return $result;
}



1;
