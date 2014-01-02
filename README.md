*comanche*
==========

*Auteurs :*
----------
Maxime Caboche, Fouad Zairi

*Principe :*
----------
Ce serveur doit être géré via une commande dont le nom doit être comanche et les fonctionnalités minimales
doivent permettre :
- la configuration du serveur via un fichier texte ;
- de traiter les requêtes GET en respectant le protocole HTTP dans sa version 1.1 ;
- de gérer les demandes de ressources via des projections sur le système de fichiers ;
- de récupérer des fichiers respectant les formats html, jpeg et texte ;
- de gérer les demandes de ressources via des projections vers l’exécution de scripts CGI ;
- de gérer un journal traçant notamment les requêtes traitées ;
- de traiter les requêtes de plusieurs clients en parallèles

*Utilisation :*
-------------
Comanche est un script ecrit en perl. Il prends en arguement 4 paramètres : 
- start
    `./comanche start`
- stop
    `./comanche stop`
- reload
    `./comanche reload`
- status
    `./comanche status`

*Limite :*
----------
- Le traitement des routes se fait par ordre de lecture de fichier de configuration. Attention à l'agencement des routes permettant l'execution de scripts CGI
- Le serveur ne peut se demarré qu'une seule fois en même temps.
- Le nombre de requetes affiché lors de la commande status est différents du nombre de requetes réelles. Le navigateur par moment envoie des requetes vide...
