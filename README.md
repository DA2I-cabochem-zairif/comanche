*comanche*
==========

Apache like in perl

Ce serveur doit être géré via une commande dont le nom doit être comanche et les fonctionnalités minimales
doivent permettre :
- la configuration du serveur via un fichier texte ;
- de traiter les requêtes GET en respectant le protocole HTTP dans sa version 1.1 ;
- de gérer les demandes de ressources via des projections sur le système de fichiers ;
- de récupérer des fichiers respectant les formats html, jpeg et texte ;
- de gérer les demandes de ressources via des projections vers l’exécution de scripts CGI ;
- de gérer un journal traçant notamment les requêtes traitées ;
- de traiter les requêtes de plusieurs clients en parallèle.

Les détails de chacune des attentes pour ces fonctionnalités sont décrites dans la suite de ce document.
La réalisation de ce projet peut être (et devrait être) incrémentale. Vous pouvez, par exemple, d’abord réaliser un serveur qui
ne traite aucune projection et ne traite qu’une requête à la fois, puis le faire évoluer en ajoutant les projections statiques sans
expressions régulières, etc.
Il s’agit par ailleurs dans un premier temps de vous documenter sur le fonctionnement d’un serveur web et donc sur sur le
protocole HTTP, le standard MIME, le langage HTML et la convention CGI.
