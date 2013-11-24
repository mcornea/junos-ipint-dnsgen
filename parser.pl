#!/usr/bin/perl
open (CONFIG, 'access-router-config.txt');
my $data = do { local $/; <CONFIG>;};
close (CONFIG);

my $system = $data =~ m{(\bsystem\s*({(?:(?>[^{}]+)|(?-1))*}))}
    ? $1
    : die "system not found";

my $intconfig = $data =~ m{(\binterfaces\s*({(?:(?>[^{}]+)|(?-1))*}))}
    ? $1
    : die "interfaces not found";

if ($ARGV[0] eq 'sys') {
    print $system;
}

if ($ARGV[0] eq 'int') { 
    if (!defined $ARGV[1]) {
        print $intconfig, "\n";
    }
    if (defined $ARGV[1]) {
        my $int = $intconfig =~ m{(\b$ARGV[1]\s*({(?:(?>[^{}]+)|(?-1))*}))}
            ? $1
            : die "$ARGV[1] not found";

        if (!defined $ARGV[2]) {
            print $int. "\n";
        }

        if (defined $ARGV[2]) {
            my $unit = $int =~m{(\bunit $ARGV[2]\s*({(?:(?>[^{}]+)|(?-1))*}))}
                ? $1
                : die "$ARGV[2] not found";

            my $inet = $unit =~ m{(\bfamily inet\s*({(?:(?>[^{}]+)|(?-1))*}))}
                ? $1
                : die "family inet not found in section";

            my $inetaddr = $inet =~ m{\baddress\s(\d{1,3}(?:\.\d{1,3}){3})}
                ? $1
                : die "no IP address";
            print $inetaddr, "\n";
        }
    }
}

if ($ARGV[0] eq '--help' or !defined $ARGV[0]) {
    print "Usage : ./parser.pl sys                              # outputs system section config", "\n";
    print "        ./parser.pl int                              # outputs interfaces section config", "\n";
    print "        ./parser.pl int [int-name]                   # outputs specific interface section config", "\n";
    print "        ./parser.pl int ge-1/1/7                     # outputs ge-1/1/7 interface section config", "\n";
    print "        ./parser.pl int [int-name] [unit-id]         # outputs specific interface unit IP address", "\n";
    print "        ./parser.pl int ge-1/1/7 1001                # outputs ge-1/1/7 interface unit 1001 IP address", "\n";
}
