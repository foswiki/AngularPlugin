# See bottom of file for license and copyright information
package Foswiki::Plugins::AngularPlugin::Service;

use strict;
use warnings;

use Foswiki::Func ();
use Foswiki::Plugins ();
use Foswiki::Plugins::AngularPlugin ();
use Foswiki::Contrib::JsonRpcContrib::Error ();
use JSON ();
use Error qw( :try );
use Data::Dump qw(dump);

sub new {
  my $class = shift;

  my $this = bless({@_}, $class);

  return $this;
}

sub tmpl {
  my ($this, $request) = @_;

  my $session = $Foswiki::Plugins::SESSION;

  # enter angular mode
  Foswiki::Func::getContext()->{angular} = 1;

  my $web = $session->{webName};
  my $topic = $request->param('topic') || $session->{topicName};
  ($web, $topic) = Foswiki::Func::normalizeWebTopicName($web, $topic);

  my $context = $request->param('context') || 'view';
  Foswiki::Func::getContext()->{$context} = 1;

  throw Foswiki::Contrib::JsonRpcContrib::Error(404, "Topic does not exist")
    unless Foswiki::Func::topicExists($web, $topic);

  my ($meta, $text) = Foswiki::Func::readTopic($web, $topic);

  my $wikiName = Foswiki::Func::getWikiName();

  throw Foswiki::Contrib::JsonRpcContrib::Error(401, "Access denied")
    unless Foswiki::Func::checkAccessPermission("VIEW", $wikiName, $text, $topic, $web, $meta);

  # propagate json-rpc params to cgi params
  my $cgiRequest = Foswiki::Func::getRequestObject();
  while (my ($key, $val) = each %{$request->param('urlparams')}) {
    $cgiRequest->param($key, $val);
  }

  # undo some jsonr-rpc params in cgi request obj ... required for TOC links
  $cgiRequest->delete("POSTDATA");

  Foswiki::Func::pushTopicContext($web, $topic);

  if ($Foswiki::cfg{Plugins}{MetaDataPlugin}{Enabled}) {
    require Foswiki::Plugins::MetaDataPlugin;
    Foswiki::Plugins::MetaDataPlugin::registerMetaData();
  }

  my $template = $request->param('template')
    || Foswiki::Func::getPreferencesValue('VIEW_TEMPLATE');

  if (!$template && $Foswiki::cfg{Plugins}{AutoTemplatePlugin}{Enabled}) {
    require Foswiki::Plugins::AutoTemplatePlugin;
    $template = Foswiki::Plugins::AutoTemplatePlugin::getTemplateName($web, $topic);
  }
  $template ||= "view";

  Foswiki::Func::loadTemplate($template);

  my $expand = $request->param("expand") || [];
  my $zones = $request->param("zones") || [];

  my %prefs = map {
    $_->{name} => $meta->expandMacros($_->{value})
  } $meta->find("PREFERENCE");

  my $result = {
    web => $meta->web,
    topic => $meta->topic,
    expand => {},
    zones => {},
    preferences => \%prefs,
  };

  # expand requested items
  foreach my $item (@$expand) {
    $result->{expand}{$item} = $this->expandTemplate($item, $meta);
  }

  # return requested zones
  foreach my $item (@$zones) {
    $result->{zones}{$item} = $this->getZoneObject($item, $meta),;
  }

  Foswiki::Func::popTopicContext();

  return $result;
}

sub getZoneObject {
  my ($this, $zone, $meta) = @_;

  my $session = $Foswiki::Plugins::SESSION;

  my @total;
  my %visited;
  my @zoneIDs = values %{$session->{_zones}{$zone}};

  foreach my $zoneID (@zoneIDs) {
    $session->_visitZoneID($zoneID, \%visited, \@total);
  }

  my @zone = ();

  foreach my $item (grep { $_->{text} } @total) {
    my @requires = map { $_->{id} } @{$item->{requires}};

    my $text = $meta->renderTML($meta->expandMacros($item->{text}));
    $text =~ s/\$id/$item->{id}/g;
    $text =~ s/\$zone/$zone/g;
    push @zone, {
      id => $item->{id},
      text => $text,
      requires => \@requires,
    };
  }

  return \@zone;
}

sub expandTemplate {
  my ($this, $template, $meta) = @_;

  my $text = $meta->text;
  $text =~ s/^\s*%(START|STOP)INCLUDE%/<!-- -->/g;

  my $tmpl = Foswiki::Func::expandTemplate($template);
  $tmpl =~ s/\%TEXT\%/$text/g;

  my $result = $tmpl;
  $result = $meta->expandMacros($result);
  $result = $meta->renderTML($result);

  my $session = $Foswiki::Plugins::SESSION;
  if ($session->{plugins}) {
    $session->{plugins}->dispatch('completePageHandler', $result, '');
  }

  # cleanup stuff
  $result =~ s/<nop>//g;
  $result =~ s/<\/?noautolink>//g;
  $result =~ s/<!--[^\[<].*?-->//g;
  $result =~ s/^\s*$//gms;
  $result =~ s/<p><\/p>\s*([^<>]+?)\s*(?=<p><\/p>)/<p class='p'>$1<\/p>\n\n/gs;
  $result =~ s/\s*<\/p>(?:\s*<p><\/p>)*/<\/p>\n/gs;    # remove useless <p>s
  $result =~ s/\%{(<pre[^>]*>)}&#37;\s*/$1/g;
  $result =~ s/\s*&#37;{(<\/pre>)}\%/$1/g;

  return $result;
}

1;
__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2014 Michael Daum http://michaeldaumconsulting.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.

