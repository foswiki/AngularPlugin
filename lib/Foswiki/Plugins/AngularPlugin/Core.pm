# See bottom of file for license and copyright information

package Foswiki::Plugins::AngularPlugin::Core;
use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin ();

=begin TML

---+ package Foswiki::Plugins::AngularPlugin::Core

This is the perl stub for the angular core. 

=cut

=begin TML

---++ ClassMethod new( $class, ... )

Constructor

=cut

use Foswiki::Plugins::AngularPlugin::Module ();
our @ISA = qw( Foswiki::Plugins::AngularPlugin::Module );


sub new {
  my $class = shift;

  my $this = bless(
    $class->SUPER::new(
      name => 'ngCore',
      version => '1.4.4',
      author => 'Brat Tech LLC, Google and community',
      homepage => 'https://angularjs.org',
      javascript => ['angular.js', ],
      puburl => '%PUBURLPATH%/%SYSTEMWEB%/AngularPlugin',
    ),
    $class
  );

  return $this;
}

=begin TML

---++ ClassMethod init( $this )

Initialize this plugin by adding the required static files to the page 

=cut

sub DIS_init {
    my $this = shift;

    return unless $this->SUPER::init();

    # open matching localization file if it exists
    my $session = $Foswiki::Plugins::SESSION;
    my $langTag = $session->i18n->language();
    my $messagePath =
        $Foswiki::cfg{SystemWebName}
      . '/AngularPlugin/i18n/angular-locale_'
      . $langTag . '.js';

    my $messageFile = $Foswiki::cfg{PubDir} . '/' . $messagePath;
    if ( -f $messageFile ) {
        Foswiki::Func::addToZone(
            'script', $this->{idPrefix}.'::I18N',
            <<"HERE", $this->{idPrefix}.'::NGCORE' );
<script id='\$id' type='text/javascript' src='$Foswiki::cfg{PubUrlPath}/$messagePath'></script>
HERE
    }
}

=begin TML

---++ ClassMethod handleNGAPP( $this, $params, $topic, $web ) -> $result

Tag handler for =%<nop>NGAPP%=. 

=cut

sub handleNGAPP {
  my ( $this, $params, $topic, $web ) = @_;

  my %ngParams = ();

  $ngParams{'ng-app'} = $params->{_DEFAULT} || '';
  $ngParams{'ng-controller'} = $params->{controller} if defined $params->{controller};
  $ngParams{'ng-init'} = $params->{init} if defined $params->{init};

  my $modules = '';
  if (defined $params->{modules}) {
    my @modules = ();
    foreach my $module (split(/\s*,\s*/, $params->{modules})) {
      push @modules, $module;
      Foswiki::Plugins::JQueryPlugin::createPlugin($module);
    }
    $modules = "'".join("', '", @modules)."'";
  }

  my $appScript = '';
  if ($ngParams{'ng-app'}) {
    $appScript = <<"HERE"
<script>
var $ngParams{'ng-app'} = angular.module('$ngParams{'ng-app'}', [$modules]);
</script>
HERE
  }

  return $appScript ."<div class='angularApp' " . join(" ", map { $_ . ($ngParams{$_} eq '' ? '' : '="' . $ngParams{$_} . '"') } keys %ngParams) . ">";
}

=begin TML

---++ ClassMethod handleEndNgApp ( $this, $params, $topic, $web ) -> $result

Tag handler for =%<nop>ENDNGAPP%=. 

=cut

sub handleENDNGAPP {
    return "</div><!-- //NGAPP -->";
}


1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2014-2015 Michael Daum http://michaeldaumconsulting.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.


