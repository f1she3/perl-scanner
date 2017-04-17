#!/usr/bin/env perl

use strict;
use warnings;
use HTTP::Request;
use LWP::UserAgent;
use Term::ANSIColor;
use File::Basename;
use Getopt::Long;
use Switch;

#Keyboard interrupt handling
local $SIG{INT} = sub {
	print color 'reset';
	print "\n";
    exit 0;
};
my $time = time;
my $file_name = basename $0;
system('clear');
print"\n";
print "------------------------------------------------\n";
print "--------------------[ PERL ]--------------------\n";
print "--------Admin Panel Finder v 1.3--------\n";
print "-------------------- F1SHE3 --------------------\n";
print "------------------------------------------------\n";
print "\n";

my $i = 0;
my $wordlist = 'wordlist.txt';
my $options = GetOptions(
    'h=s'   => \my $host,
    'l=s'   => \my $custom_wordlist,
    't=i'   => \my $cool_down,
    'v'   	=> \my $verbose,
);
if(defined($custom_wordlist)){
	$wordlist = $custom_wordlist;
}
if(!defined($host)){
    print "Usage   : perl ./$file_name -h <site> -l <wordlist>\n";
    print "Exemple : perl ./$file_name -h site.com -l wordlist.txt\n\n";
    print "\"perldoc $file_name\" for more informations\n\n";
    exit 1;
}
chomp $host;
$host = lc($host);
if($host){
	if($host !~ /^https?:/){
		$host = 'http://'.$host;
	}
    if($host !~ /\/$/){                                                                                                              
        $host = $host.'/';
    }
    if($host !~ /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/){
		if($host !~ /^(https?:\/\/)[0-9]{1,3}(\.([0-9]){1,3}){3}\/$/){
			print color 'red';
			print "\n[FATAL ERROR] Invalid URL\n\n";
			exit;
		}
    }
    if(defined($cool_down)){
		if($cool_down !~ /^[0-9]{1,}$/){
			$cool_down = 0;
		}
	
	}else{
		$cool_down = 0;
	}
	if(open(LIST, $wordlist)){
		print color 'yellow';
		print "[SCANNING] $host\n\n";
		while(my $list = <LIST>){
			chomp $list;
			my $final = $host.$list;
			my $req = HTTP::Request->new(GET=>$final);
			my $ua = LWP::UserAgent->new();
			$ua->timeout(30);
			my $page = $ua->request($req);
			switch($page->code()){
				case 404{
					if(defined($verbose)){
						print color 'red';
						print "[-] Not Found -> ";
						print $final, "\n";
						sleep($cool_down);
					
					}else{
						sleep($cool_down);
					}
				}
				case(403){
					print color 'yellow';
					print "[!] Forbidden -> ";
					print $final, "\n";
					my $i = 1;
					sleep($cool_down);
				}
				case(200){
					print color 'green';
					print "[+] Access OK -> ";
					print $final, "\n";
					$i = 1;
				}
				default{
					print color 'BRIGHT_YELLOW';
					print "[*] HTTP ", $page->code(), "  -> ";
					print $final, "\n";
					$i = 1;
				}
			}
		}

	}else{
		print color 'red';
		print  "[FATAL ERROR] wordlist $wordlist wasn't found !\n\n";
		exit;
	}
}
$time = time-$time;
if(!$i){
	print color 'red';
	print "NOTHING FOUND !\n";
}
print color 'green';
print "\nEND (",$time, "s)\n\n";
print color 'reset';
exit;

__END__

=head1 VERSION
Version 1.4

=head1 AUTHOR

F1SHE3

=head1 DESCRIPTION

Admin panel bruteforcer that comes with several (cool) options

=head1 OPTIONS

=head2 -h (host, required)
	The target, a domain name or an ip address

=head2 -l (wordlist, defautl to wordlist.txt)
	The wordlist to use for the bruteforce, a .txt file

=head2 -t (time, default to 0)
	Number that defines the time number of sec to wait between the 404 requests

=head2 -v (verbose, default to none)
	Verbose mode, shows all requests (even 404)

=head1 MORE
Please give your suggestions / reports to the github repo
