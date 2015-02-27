# See bottom of file for license and copyright information

package Foswiki::Plugins::AngularPlugin::Fx;
use strict;
use warnings;

use Foswiki::Plugins::AngularPlugin::Module ();
our @ISA = qw( Foswiki::Plugins::AngularPlugin::Module );

sub new {
  my $class = shift;

  my $this = bless(
    $class->SUPER::new(
      name => 'ngFx',
      version => '1.11.8',
      author => 'Scott Moss',
      homepage => 'https://hendrixer.github.io',
      javascript => ['ngFx.js', ],
      dependencies => ['ngCore', 'ngAnimate'],
    ),
    $class
  );

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



