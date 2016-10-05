#!/usr/bin/perl -w

use strict;
use HTTP::Request;
use LWP::UserAgent;
use Term::ANSIColor;																														#Shell colors
use File::Basename;																															#Get the filename
use Getopt::Long;																															

my($time,$file_name,$address, $c_down,$wordlist,$f, $results, $verbose);
my($final,$req,$ua,$page,$f_page,$b_page,$s_page,$content,$f_content,$b_content,$s_content);
$time = time;
$file_name = basename $0;
print color 'reset';
print"\n";
print "------------------------------------------------\n";
print "--------------------[ PERL ]--------------------\n";
print "--------Admin Control Panel Finder v 1.2--------\n";
print "--------------------- R04A ---------------------\n";
print "------------------------------------------------\n";
print "\n";

$results = GetOptions(
    'h=s'   => \$address,
    'l=s'   => \$wordlist,
    't=i'   => \$c_down,
    'v'   	   => \$verbose,
);
																																			#lc : URL -> url
if(!defined($address) || !defined($wordlist)){
    print "Usage   : perl ./$file_name <site> <wordlist>\n";
    print "Exemple : perl ./$file_name -h site.com -l wordlist.txt\n";
    print "Exemple : perl ./$file_name -h http://site.com -l wordlist.txt\n\n";
    print "Type 'perldoc $file_name' for more informations\n\n";
    exit;
}
chomp $address;
$address = lc($address);																										
if($address){
	if($address !~ /^(https?:\/\/)/){
		$address = 'http://' . $address;
	}
	
    if($address !~ /\/$/){                                                                                                              
        $address = $address . '/';
    }
    if($address !~ /^(https?:\/\/)[a-zA-Z0-9\\\/\.-]/){                                                                 					#Checking http format
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
    $final = $address.'dd/dd/dd/E/X.php';                                                                                					#404
    $req = HTTP::Request->new(GET=>$final);
    $ua = LWP::UserAgent->new();
    $ua->timeout(20);
    $f_page = $ua->request($req);
    $f_content = $f_page->content;				                                                                               
    
    $final = $address.'test.%EXT%';
    $req = HTTP::Request->new(GET=>$final);
    $ua = LWP::UserAgent->new();
    $ua->timeout(20);
    $b_page = $ua->request($req);
    $b_content = $b_page->content;
    
    $final = $address.'§!£%µ/';
    $req = HTTP::Request->new(GET=>$final);
    $ua = LWP::UserAgent->new();
    $ua->timeout(20);
    $s_page = $ua->request($req);
    $s_content = $b_page->content;
 
	if(open(LIST, $wordlist)){
		print color 'yellow';
		print "[SCANNING] $address\n\n";
		while(my $list = <LIST>){
			print color 'reset';
			chomp $list;
			$final = $address.$list;
			$req = HTTP::Request->new(GET=>$final);
			$ua = LWP::UserAgent->new();
			$ua->timeout(20);
			$page = $ua->request($req);
			$content = $page->content;
			if($content ne $f_content && $content ne $b_content && $content ne $s_content && $content !~ /error/ && $content !~ /404/ && $content !~ /not found/ && $content !~ /Not Found/ && $content !~ /Error 404/ || $content =~ /RewriteEngine/ || $content =~ /.htaccess/ || $content =~ /ErrorDocument/){
				if(($content =~ /403/ || $content =~ /Forbidden/ || $content =~ /You don't have permission to access/ || $content =~ /401/ || $content =~ /Unauthorized/) && $content !~ /RewriteEngine/){
					print color 'yellow';
					print "[*] Forbidden -> ";
					print $final, "\n";
					$f = 1;
					print color 'reset';
					sleep($c_down);
				
				}else{
					print color 'green';
					print "[+] Response  -> ";
					print $final, "\n";
					$f = 1;
					print color 'reset';
				}
					
			}else{
				if(defined($verbose)){
					print color 'red';
					print "[-] Not Found -> ";
					print $final, "\n";
					sleep($c_down);
				}else{
					print color 'reset';
					sleep($c_down);
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

if(!$f){
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

Version 1.2 Stable

=head1 DATE

26/06/2016

=head1 AUTHOR

R04A

=head1 DESCRIPTION

This is a nice perl admin page finder that can be used with several options, let's discover them !

=head1 ALL THE OPTIONS

=head2 -h (host)
	The target, a domain name or an ip address

=head2 -l (list or wordlist)
	The wordlist to use for the attack, a .txt file. See the exemple

=head2 -t (time, default to 0)
	Number that defines the time (sec) to wait between the 404 requests.

=head2 -v (verbose, default to none)
	Verbose mode, shows all the requests, even the 404

=head1 MORE
Please report any problem or commentary to the github repo, do not use it against websites that aren't yours.
