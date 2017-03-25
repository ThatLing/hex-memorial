#!/usr/local/bin/perl -w

  # $Id: 4200wx.pl 2 2008-07-10 00:05:58Z yaakov $

  # Current Weather Condition on an HP 4200 Printer 
  # 
  # This program gets METAR weather conditions from teh NOAA webiste and uses
  # Geo::METAR to parse the result.  It then hard formats the result so it
  # looks reasonably good on the 4200's display.
  #
  # The program need to know the four-letter ICAO airport code for your area,
  # as well as the IP address of the target printer.  I run this program as a
  # cron job at 10 minute intervals.  You can change the "WEATHER CONDITIONS"
  # heading to reflect your cities name.  You will have to pad it properly
  # to center it.
  #
  # THIS PROGRAM IS PROVIDED WITH NO WARRANTY OF ANY KIND EXPRESSED OR IMPLIED
  # THE AUTHOR CANNOT BE RESPONSIBLE FOR THE EFFECTS OF THIS PROGRAM
  # IF YOU ARE UNCERTAIN ABOUT THE ADVISABILITY OF USING IT, DO NOT!
  #
  # Yaakov (http://kovaya.com/)

use strict;

use LWP::Simple;
use IO::Socket;

use Geo::METAR;
my $m = new Geo::METAR;

my $wx = getmetar('KORD');          # Put your ICAO code here
setdisplay($wx, '169.254.10.10');   # This should be your printer's IP

sub getmetar {
  my $icao = shift;
  my $page = get("http://weather.noaa.gov/cgi-bin/mgetmetar.pl?cccc=$icao") or exit;

  $page =~ /($icao .+)/;
  my $report = $1;

  $m->metar($report);

  my $wx;
    $wx = " WEATHER CONDITIONS ";   # This can be edited to localize it.
                                    # Keep it the same length and center
                                    # the text in the quotes with spaces.

    my $temp = $m->TEMP_F."F/".$m->TEMP_C."C";
    my $pad = (20 - length $temp)/2;
    $wx .= " " x $pad.$temp." " x $pad;

    my $vis = $m->VISIBILITY;
    $vis =~ /(\d+)/;
    my $atmos = "visibility $1 mi.";
    $pad = (20 - length $atmos)/2;
    $wx .= " " x $pad.$atmos." " x $pad;

    my $wspd = $m->WIND_MPH;
    my $wind = "Wind $wspd mph";
    $pad = (20 - length $wind)/2;
    $wx .= " " x $pad.$wind." " x $pad;
    
return $wx;

}

sub setdisplay {

  my $rdymsg = shift; my $peeraddr = shift;
  my $socket = IO::Socket::INET->new(
      PeerAddr	=> $peeraddr,
      PeerPort	=> "9100",
      Proto     => "tcp",
      Type	=> SOCK_STREAM
  ) or die "Could not create socket: $!";

my $data = <<EOJ
\e%-12345X\@PJL JOB
\@PJL RDYMSG DISPLAY="$rdymsg"
\@PJL EOJ
\e%-12345X
EOJ
;

  print $socket $data;

}