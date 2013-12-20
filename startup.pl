#!/usr/bin/perl
use Socket;
if($#ARGV == 0){
    chomp($ARGV[0]);
    if($ARGV[0] eq "start"){
	print "Le serveur s'est bien démarré.\n";
	$retour_du_fork=fork; #Premier fork permettant de gerer le serveur hors du star/stop
	if($retour_du_fork==0){ # SERVEUR
	    socket (SERVEUR, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
	    setsockopt (SERVEUR, SOL_SOCKET, SO_REUSEADDR, 1);
	    $mon_adresse = sockaddr_in ("8080", INADDR_ANY);
	    bind(SERVEUR, $mon_adresse) || die ("bind $!");
	    listen (SERVEUR, SOMAXCONN) || die ("listen");
	    while(accept (CLIENT, SERVEUR) || die ("accept")){
		$retour_du_fork = fork; # Nouveau Thread pour chaque connection 
		
		if($retour_du_fork == 0){
		    select (CLIENT);
		    $requete = <CLIENT>;
		    %params = parse_request($requete);
		    @stats = stat("/".$params{"path"} ."/". $params{"file"});
		    print "HTTP/1.1 200 OK\r\n" .
			"Content-Type: text/html; charset=utf-8\r\n" .
			"Content-Length: " . $stats[7] . "\r\n\r\n";
		    open(PAGE, "/".$params{"path"} ."/". $params{"file"});
		    while(<PAGE>){ print $_; }
		    close(PAGE);
		    close(CLIENT);
		    exit 0;
		}
		elsif($retour_du_fork != 0){
		    close(CLIENT);
		}
	    }
	    close (CLIENT);
	    close (SERVEUR);
	}
	else{
	    open(PID, ">start");
	    print PID "$retour_du_fork";
	    close(PID);
	}
    }
    elsif($ARGV[0] eq "stop"){
	print "Fin du serveur\n";
	print "$pidserv \n";
	open(PID,"start");
        $pid=<PID>;
	close(PID);
	kill SIGQUIT, $pid;
	print $pid,"\n";
	exit 0;
    }
   else{
	print "Parametre inconnu \n";
	print "Usage : start|stop";
    }
   
}else{
    print "Nombre de paramatre incorrect \n";
    print "Usage : start|stop\n";
}

sub get_request
{
    %set = lireFichier();
    socket(SERVEUR, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
    $adresse = inet_aton(@ARGV[0]) || die("inet_aton");
    $adresse_complete = sockaddr_in($set{"port"}, $adresse) || die ("sock_addr");
    connect(SERVEUR,$adresse_complete) || die("connect");

    autoflush SERVEUR 1;
    printf SERVEUR "GET /$ARGV[1] HTTP/1.1\n";
    printf SERVEUR "Host:$ARGV[0]\n";
    printf SERVEUR "\n";

    while (<SERVEUR>)
    {
	print $_;
    }

    close (SERVEUR);
}

sub parse_request
{
    @parse = split(" ",$_[0]);
    @request = split("/", $parse[1]);
    $client = $request[0],"\n";
    $fichier = $request[$#request],"\n";
    $chemin = "$request[1]";
    for ($i = 2 ; $i < $#request ; $i++)
    {
	$chemin = "$chemin/$request[$i]";
    }
    return ("client" => $client, "path" => $chemin, "file" => $fichier);
}


sub parse_conf
{
    %conf = ();
    open(CONF,"comanche.conf");
    while(<CONF>)
    {
	chomp;
	@tmpset = split('\s',$_) if(/set/);
	@tmproute = split('\s',$_) if(/route/);
	@tmpexec = split('\s',$_) if(/exec/);
	if ($tmpset[0] ne "")
	{
	    $conf{"$tmpset[1]"} = "$tmpset[2]";
	}
	if ($tmproute[0] ne "")
	{
	    $conf{"route1"} = "$tmproute[1]";
	    $conf{"route2"} = "$tmproute[3]";
	}
	if ($tmpexec[0] ne "")
	{
	    $conf{"exec1"} = "$tmpexec[3]";
	    $conf{"exec2"} = "$tmpexec[3]";
	}
	
    }
    return %conf;
}
