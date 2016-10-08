#!/usr/bin/perl -w

use strict;
use HTTP::Request;
use LWP::UserAgent;
use Term::ANSIColor;																														#Colors
use File::Basename;																															#Get the filename
use Getopt::Long;																															

my($time,$file_name,$host,$c_down,$wordlist,$i,$options,$verbose,$list);
my($final,$req,$ua,$page);
$time = time;
$file_name = basename $0;
system('clear');
print color 'reset';
print"\n";
print "------------------------------------------------\n";
print "--------------------[ PERL ]--------------------\n";
print "--------Admin Control Panel Finder v 1.3--------\n";
print "-------------------- F1SHER --------------------\n";
print "------------------------------------------------\n";
print "\n";

$options = GetOptions(
    'h=s'   => \$host,
    'l=s'   => \$wordlist,
    't=i'   => \$c_down,
    'v'   	=> \$verbose,
);

if(!defined($host) || !defined($wordlist)){
    print "Usage   : perl ./$file_name -h <site> -l <wordlist>\n";
    print "Exemple : perl ./$file_name -h site.com -l wordlist.txt\n\n";
    print "Type 'perldoc $file_name' for more informations\n\n";
    exit;
}
chomp $host;
$host = lc($host);																															#Lowcase																										
if($host){
	if($host !~ /^https?:/){
		$host = 'http://' . $host;
	}
    if($host !~ /\/$/){                                                                                                              
        $host = $host . '/';
    }
    if($host !~ /^https?:[a-zA-Z0-9\\\/\.-]/){	                                                                 						#Checking http pattern
        print color 'red';
        print "\n[FATAL ERROR] Invalid URL\n\n";
        print color 'reset';
        exit;
    }
    if(!defined($c_down)){
		$c_down = 0;
	
	}else{
		if($c_down !~ /^[0-9]{1,}$/){
			$c_down = 0;
		}
	}
	if(open(LIST, $wordlist)){
		print color 'yellow';
		print "[SCANNING] $host\n\n";
		while($list = <LIST>){
			print color 'reset';
			chomp $list;
			$final = $host.$list;
			$req = HTTP::Request->new(GET=>$final);
			$ua = LWP::UserAgent->new();
			$ua->timeout(30);
			$page = $ua->request($req);
			if($page->code() == 404){
				if(defined($verbose)){
					print color 'red';
					print "[-] Not Found -> ";
					print $final, "\n";
					sleep($c_down);
				
				}else{
					print color 'reset';
					sleep($c_down);
				}
			
			}else{
				if($page->code() == 403){
					print color 'yellow';
					print "[!] Forbidden -> ";
					print $final, "\n";
					$i = 1;
					print color 'reset';
					sleep($c_down);
				
				}else{
					if($page->code() == 200){
						print color 'green';
						print "[+] Access OK -> ";
						print $final, "\n";
						$i = 1;
						print color 'reset';
					
					}else{
						print color 'BRIGHT_YELLOW';
						print "[*] HTTP ", $page->code(), "  -> ";
						print $final, "\n";
						$i = 1;
						print color 'reset';
					}
				}
			}
		}

	}else{
		print color 'red';
		print  "\n[FATAL ERROR] wordlist $wordlist wasn't found !\n\n";
		print color 'reset';
		exit;
	}
}

$time = time-$time;

if(!$i){
	print color 'red';
	print "NOTHING FOUND !\n";
	print color 'reset';
}
print color 'green';
print "\nEND (",$time, "s)\n\n";
print color 'reset';
exit;

__END__

=head1 VERSION

Version 1.3 Beta

=head1 DATE

26/06/2016

=head1 AUTHOR

F1SHER

=head1 DESCRIPTION

This is a nice perl admin page finder that can be used with several options, such as a cooldown between 404 requests

=head1 OPTIONS

=head2 -h (host)
	The target, a domain name or an ip address

=head2 -l (list or wordlist)
	The wordlist to use for the attack, a .txt file. See the exemple

=head2 -t (time, default to 0)
	Number that defines the time (sec) to wait between the 404 requests

=head2 -v (verbose, default to none)
	Verbose mode, shows all the requests, even the 404

=head1 MORE
Please report any problem or commentary to the github repo, do not use it against websites that aren't yours.

