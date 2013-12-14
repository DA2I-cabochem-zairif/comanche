#!/usr/bin/perl
use Socket;
if($#ARGV == 0){
    chomp($ARGV[0]);
    if($ARGV[0] eq "start" && -f "start" ){
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
		    print CLIENT "HTTP/1.1 200 OK\r\n\r\n"; #ENTETE
		    print $requete;
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
	elsif($retour_du_fork != 0){ # START|STOP
	    open(PID, ">start");
	    print PID "$retour_du_fork";
	    close(PID);
	}
    }
    elsif($ARGV[0] eq "stop"){
	print "Fin du serveur\n";
	#TODO : Arret du Serveur
    }
    else{
	print "Parametre inconnu \n";
	print "Usage : start|stop";
    }
   
}else{
    print "Nombre de paramatre incorrect \n";
    print "Usage : start|stop";
}
