# See bottom of file for license and copyright information

package Foswiki::Plugins::AngularPlugin::Module;
use strict;
use warnings;

=begin TML

---+ package Foswiki::Plugins::AngularPlugin::Module

abstract class for Angular.JS modules

=cut

use Foswiki::Plugins::JQueryPlugin::Plugin ();
our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );


=begin TML

---++ ClassMethod new( $class, ... )

   * =$class=: Module class
   * =...=: additional properties to be added to the object. i.e. 
      * =author => 'moduleAuthor'= (default 'unknown')
      * =debug => 0 or 1= (default =$Foswiki::cfg{AngularPlugin}{Debug}=)
      * =dependencies => []=
      * =documentation => 'moduleDocumentation'= (default JQuery&lt;Name>)
      * =homepage => 'moduleHomepage'= (default unknown)
      * =javascript => []
      * =name => 'moduleName'= (default unknown)
      * =puburl= => 'pubUrl'= (default =%PUBURLPATH%/%SYSTEMWEB%/AngularPlugin=)
      * =summary => 'moduleSummary'= (default undefined)
      * =tags= => []
      * =version => 'moduleVersion'= (default unknown)

=cut

sub new {
  my $class = shift;

  my $this = bless({
      author => 'unknown',
      css => [],
      debug => $Foswiki::cfg{AngularPlugin}{Debug} || 0,
      dependencies => [],
      documentation => undef,
      homepage => 'unknown',
      javascript => [],
      name => $class,
      puburl => undef,
      summary => undef,
      tags => [],
      version => 'unknown',
      idPrefix => 'ANGULARPLUGIN',
      @_
    },
    $class
  );

  $this->{documentation} = $Foswiki::cfg{SystemWebName} . '.Angular' . ucfirst($this->{name})
    unless defined $this->{documentation};

  $this->{documentation} =~ s/:://g;

  $this->{puburl} = '%PUBURLPATH%/%SYSTEMWEB%/AngularPlugin/modules/' . $this->{name}
    unless defined $this->{puburl};

  return $this;
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
