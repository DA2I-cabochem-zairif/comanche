
Projet
======

Binôme
------

- Maxime Caboche
- Fouad Zairi

Résumé
------
  - [X] gestion du port d'coute
  - [X] protocole HTTP/1.1
  - [X] gestion de la page par dfaut
  - [X] gestion des fichiers index dans les rpertoires
  - [X] gestion des logs
  - [X] gestion des clients en //
  - [X] gestion du max de clients
  - [X] routes statiques
  - [X] routes avec expression rgulire
  - [X] cgi statiques
  - [X] cgi avec expression rgulire
  - [ ] paramtres de cgi

Détail
------
### Gestion du port d'coute
Comanche est capable d'coute sur le port configur dans le fichier de configuration. Cependant si la configuration est recharge avec la commande `perl comanche reload`, la mise  jour du port d'coute ne s'effectue pas correctement.

### protocole HTTP/1.1
Comanche réponds uniquement en respectant le protocole HTTP/1.1 dfinis dans la [RFC 2616](www.ietf.org/rfc/rfc2616.txt). Il est capable de repondre  trois erreures standard : 
- 404 : Page non trouve.
- 400 : Protocole non respect.
- 501 : Service non disponible.

### Gestion de la page par défaut
Comanche utilise la page par defaut comme page  renvoy si il y a une erreur de type 404. En effet, le client doit tre inform que la page demand n'existe pas  travers un message d'erreur ainsi qu'un header contenant le code "404 Not found"

### Gestion des logs
Comanche est capable de gerer un fichier de log configurable dans le fichier de configuration de comanche (comanche.conf). Ce fichiers de log recense plusieurs actions : 
- Demarrage du serveur.
- Accs aux pages.
- Execution de CGI.
- Requtes retournant une erreur 404.
- Arret du serveur.

### Gestion des clients en parallèle
Comanche est capable de deservir plusieurs clients en simultannes grace  l'utilisation d'un fork pour chaques clients qui se connectent.

### Gestion du max de clients
Comanche est capable aussi grce au fichier de configuration de limiter le nombre de clients qui font une requte en simultanne. Ce nombre de clients est configurable via le fichier de configuration.

### Routes statiques
Comanche gere un systeme de "routing" permettant la rcriture d'url comme sous apache2 via le module rewrite.

### Routes avec expression régulière
Afin de dynamiser le systeme de récriture d'url, un systme utilsant les expressions régulières a été mis en place.

### CGI statiques
Les CGI sont utilis afin de dynamiser les sites web que peux hebergs comanche. Ce systme permet de dynamiser les sites web grce  l'utilisation de langages de programmations tel que python, bash, perl etc...

### CGI avec expressions régulires
L'utilisation des expressions régulires dans le parametrages des cgi permet de gnraliser les url vers l'xecution des scripts. Cette pratiques permet tout commes pour les routes de simplifier l'accs  celle-ci.

### Paramtres de cgi
Les parametres permettent de dynamiser d'avantage le rendus des pages. Malheuresement dans cette version les paramètres des cgi ne sont pas pris en comptes. [En savoir plus sur les CGI](http://www.ietf.org/rfc/rfc3875)


Développement
=============

Implémentation
--------------

### Dtermination du type du fichier  utiliser
Afin de rpondre correctement aux protocole HTTP/1.1, comanche doit tre capable de determiner le type mime de la ressource qui lui ai demand. Lors de l'implementation plusieurs mthodes peuvent tre utilis afin de repondre  cette demande : 
- l'utilisation de modules permettant de determiner le type mime est une solution qui peut etre envisag mais cependant elle oblige l'utilisateur de comanche d'installer le module en question.
- Une autre solution aurait etait d'utiliser le fichier /etc/mime.types cependant l'utilisation de ce fichier limite l'execution du serveur sur un systeme unix.
- La derniere solution qui  donc etait choisit etait de determin le type mime  partir de l'extention de la ressource. Dans le projet il y  donc une correspondance qui s'effectue entre l'extention et le mimetype crit directement dans le code de comanche. 


### Accès aux processus
L'accès aux processus se fait à l'aide de la comande `fork`. Le script initialise le serveur dans un processus fille afin de rendre la mains directement à l'utilisateur. Ensuite afin d'informé le serveur que l'on veut effectué des actioins on utilise 4 signaux :
-    $SIG{CHLD} : permettant d'indiqué au proccesus père (le serveur) la mort d'un fils (d'un client) 
-    $SIG{USR1} : permet d'obtenir les informations sur le serveur
-    $SIG{QUIT} : permet d'indiquer aux serveur qu'il doit s'arreter
-    $SIG{HUP}  : permet de recharger la configuration du serveur. 

### Fichier de configurations 
Le fichier de configuration est lu par comanche afin de reglé quelques variables comme par exemples le port d'écoute du serveur. Ces paramètres sont stocké dans un hash sous la forme : 
- $conf{global}{...} pour les paramètres globale tel que le port le fichier par défaut, etc...
- $conf{routes}{...} pour les paramètres de type "route ma_route to dossier_dest"
- $conf{exec}{...} pour les paramètres de type "exec unCGI from un_dossier"
La procédure est lancé au demarage du serveur ainsi lorsque l'on demande aux serveur de recharger la configuration via la commance `./comanche reload`

Gestion
-------

Expliquez ici en quelques lignes comment a été faite la répartition des tâches dans le développement du projet entre les membres du binôme, puis supprimez cette ligne.

Autres
------

Donnez ici toutes les autres informations qui vous paraissent importantes.
