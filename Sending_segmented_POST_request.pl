#!/usr/bin/perl



use IO::Socket;
use IO::Socket::SSL;
#use Net::Address::IP::Local;

$serv = open_server_conn("1.1.1.1","443","1", "15001" );

if ($serv =~ failed ) {
print "serv conn failed";
}
$serv1 = open_server_conn("1.1.1.1","443","1", "15002" );
if ($serv1 =~ failed ) {
print "serv1 conn failed";
}



$| = 1;
print $serv 
"POST /cgi/login HTTP/1.1
Host: 1.1.1.1
Content-Length:30

login=Complex1&passwd=Complex1
";
while (<$serv>) {
 print ;
 if ($_ =~ /Set-Cookie: A=(\w*)/i) {
                $Cookie_a= $1;
last;
 }
}

sleep(1);

$serv2 = open_server_conn("1.1.1.1","443","1", "1500" );

my $post ="login=Complex1&passwd=Complex1";
my $post2 ="login=Complex2&passwd=Complex2";
my $post3 ="login=Complex3&passwd=Complex3";
my $post4 ="login=Complex4&passwd=Complex4";
my $post5 ="login=Complex5&passwd=Complex5";

$| = 1;
print $serv2
"POST /post.pl HTTP/1.1\r
Cookie: A=$Cookie_a\r
Connection: Keep-Alive\r
Content-Length: 30000\r

";
for ($i=1;$i<=1000;$i++) {
print $serv2 $post2;
}
print $serv2 "Host: 1.1.1.1\r
";
#sleep(2);
#print $serv2 $post3;
#sleep(2);
#print $serv2 $post4;
#sleep(2);
#print $serv2 $post5;
while (<$serv2>) {

 print ;
 print "serv2/n" ;
last;

}

sub open_server_conn
{
        $host = shift;
        $port = shift;
        $isSSL = shift;
		$localport = shift;
        $cert = shift;
        $key = shift;

    my $server;
    if ($isSSL eq "1") #creating a socket for port 443 (https or ssl)
    {
#                 $port = "443";
        $server= new IO::Socket::SSL(
                            Domain => PF_INET,
                            PeerAddr => $host,
                            PeerPort => $port,
                            LocalPort => $localport,
							ReuseAddr => 1,
                            Proto => 'tcp',
                            SSL_use_cert => 1,
                                                        SSL_key_file => $key,
                                                        SSL_cert_file => $cert,
                                                        SSL_reuser_ctx => $server,
                                                        SSL_verify_mode => 0*01);
        return "Connection failed : ".IO::Socket::SSL::errstr()."\n" unless (defined $server);
    }
    else # creating a socket for port 80 (http)
    {
#                $port = "80";
        $server = IO::Socket->new(
                Domain => PF_INET,
                Proto => 'tcp',
                PeerAddr => $host,
				LocalPort => $localport,
				ReuseAddr => 1,
                PeerPort => $port
                );
        return "Connect failed : $!\n" unless $server;
    }

    return $server; #returns socket filehandler on success else displays a message " connect failed"
}
