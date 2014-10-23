#!/usr/bin/perl -wT
use Getopt::Long;
delete @ENV{qw(PATH IFS CDPATH ENV BASH_ENV)};   # Make %ENV safer

sub usage { "Usage: $0 [multicast][broadcast]\n" }

my $setBroadcast = 0;       # handled locally
my $setMulticast = 0;       # handled locally
my $MBFilter = 0;

# Process options.
if ( @ARGV > 0 && @ARGV < 3 )
{
    GetOptions('multicast' => \$setBroadcast,
	       'broadcast' => \$setMulticast);
}
#die usage;

if($setMulticast > 0)
{
    $MBFilter += 1;
}
if($setBroadcast > 0)
{
    $MBFilter += 2;
}

#iwpriv wlan0 setMCBCFilter 3
system("/sbin/iwpriv", "wlan0", "setMCBCFilter", "".$MBFilter);


