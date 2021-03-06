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
  if ($context eq "view") {
    $session->{request}->action("view");
  }

  my $cgiRequest = Foswiki::Func::getRequestObject();
  $cgiRequest->method("jsonrpc");

  Foswiki::Func::pushTopicContext($web, $topic);

  if (Foswiki::Func::getContext()->{NatSkinPluginEnabled}) {
    require Foswiki::Plugins::NatSkinPlugin;
    Foswiki::Plugins::NatSkinPlugin::init();
  }

  my $cache = $session->{cache};
  if ($cache) {
    my $cachedPage = $cache->getPage($web, $topic);
    if ($cachedPage) {
      #print STDERR "found angular tmpl in cache for $web.$topic\n";
      Foswiki::Func::popTopicContext();
      return $this->json->decode(Encode::decode_utf8($cachedPage->{data}));
    }
    #print STDERR "computing angular tmpl for $web.$topic\n";
  }

  throw Foswiki::Contrib::JsonRpcContrib::Error(404, "Topic does not exist")
    unless Foswiki::Func::topicExists($web, $topic);

  my ($meta, $text) = Foswiki::Func::readTopic($web, $topic);

  my $wikiName = Foswiki::Func::getWikiName();

  throw Foswiki::Contrib::JsonRpcContrib::Error(401, "Access denied")
    unless Foswiki::Func::checkAccessPermission("VIEW", $wikiName, $text, $topic, $web, $meta);

  # propagate json-rpc params to cgi params
  while (my ($key, $val) = each %{$request->param('urlparams')}) {
    $cgiRequest->param($key, $val);
  }

  # undo some jsonr-rpc params in cgi request obj ... required for TOC links
  $cgiRequest->delete("POSTDATA");

  if ($Foswiki::cfg{Plugins}{MetaDataPlugin}{Enabled}) {
    require Foswiki::Plugins::MetaDataPlugin;
    Foswiki::Plugins::MetaDataPlugin::registerMetaData();
  }

  my $template = $cgiRequest->param('template')
    || Foswiki::Func::getPreferencesValue('VIEW_TEMPLATE');

  if (!$template && $Foswiki::cfg{Plugins}{AutoTemplatePlugin}{Enabled}) {
    require Foswiki::Plugins::AutoTemplatePlugin;
    $template = Foswiki::Plugins::AutoTemplatePlugin::getTemplateName($web, $topic);
  }
  $template ||= "view";

  Foswiki::Func::readTemplate("view") 
    unless Foswiki::Func::readTemplate($template);

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

  if ($cache) {
    my $oldHttpCompress = $Foswiki::cfg{HttpCompress};
    $Foswiki::cfg{HttpCompress} = 0;
    $cache->cachePage("application/json", $this->json->encode($result));
    $Foswiki::cfg{HttpCompress} = $oldHttpCompress;
  }

  Foswiki::Func::popTopicContext();

  return $result;
}

sub getZoneObject {
  my ($this, $zone, $meta) = @_;

  my $session = $Foswiki::Plugins::SESSION;

  my @zone = ();
  my $excludeFromZone = $Foswiki::cfg{AngularPlugin}{ExcludeFromZone};

  foreach my $item (grep { $_->{text} } $this->getZoneItems($zone)) {
    if ($excludeFromZone && $item->{id} =~ /$excludeFromZone/g) {
      #print STDERR "excluding $item->{id}\n"; 
      next;
    }
    #print STDERR "id=$item->{id}\n"; 
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

sub getZoneItems {
  my ($this, $zone) = @_;

  my $session = $Foswiki::Plugins::SESSION;
  my $zonesHandler;

  if ($session->can("zones")) {
    # Foswiki > 2.0.3: zones are stored in a sub-component
    $zonesHandler = $session->zones();
  } else {
    # Foswiki <= 2.0.3: zones are stored in the session object
    $zonesHandler = $session;
  }

  my @zoneItems = values %{$zonesHandler->{_zones}{$zone}};
  my %visited = ();
  my @result = ();

  foreach my $item (@zoneItems) {
    $zonesHandler->_visitZoneID($item, \%visited, \@result);
  }

  return @result;
}

sub expandTemplate {
  my ($this, $template, $meta) = @_;

  my $text = $meta->text;
  $text =~ s/^\s*%(START|STOP)INCLUDE%/<!-- -->/g;
  $text .= "\n" unless $text =~ /\n$/; # make TML happy

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
  $result =~ s/<\/?(?:dirtyarea|nop|noautolink|sticky|literal)>//g;
  $result =~ s/<!--[^\[<].*?-->//g;
  $result =~ s/^\s*$//gms;
  $result =~ s/<p><\/p>\s*([^<>]+?)\s*(?=<p><\/p>)/<p class='p'>$1<\/p>\n\n/gs;
  $result =~ s/\s*<\/p>(?:\s*<p><\/p>)*/<\/p>\n/gs;    # remove useless <p>s
  $result =~ s/\%\{(<pre[^>]*>)\}&#37;\s*/$1/g;
  $result =~ s/\s*&#37;\{(<\/pre>)\}\%/$1/g;

  return $result;
}

sub json {
  my $this = shift;

  unless (defined $this->{json}) {
    $this->{json} = JSON->new->convert_blessed(1);
  }

  return $this->{json};
}

1;
__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2014-2016 Michael Daum http://michaeldaumconsulting.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
