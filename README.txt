===============================================
Potimart : SIG libre dédié au transport public.
===============================================

POTIMART signifie Programmes Opensource pour le Traitement de l’Information Multimodale et l’Analyse des Réseaux de Transport.

Une réponse à des besoins forts
- Actuellement, le manque de fonctions SIG dédiées au transport public (environnement métier fort)
- Problématique d’échange de données entre réseaux, d’analyses territoriales
- Besoin de capitaliser sur de multiples développements spécifiques et/ou locaux
- Manque d’offres commerciales pour réseaux de petites et moyennes tailles

Une vision communautaire
- Logiciel 100% opensource
- Constitution d’une large communauté de développeurs/utilisateurs
- Documentation intégrée
- Communication internationale

Pour quels utilisateurs ?
- Réseaux de transport (saisie, validation, cartographie, analyses de base ...)
- Institutions (publications de données normalisées, cartographies multi réseaux...)
- Bureaux d’étude, agences d’urbanisme (cartographies, analyses avancées...)
- Développeurs (validation d’algorithmes...)
- Grand public (information voyageur multimodale, guidage piéton/TC...)

Les ambitions de ce projet soutenu par la PREDIM sont de développer une suite logicielle sous licence Open Source composée de :

=> Modules d'import de données : pour représenter différents types de réseaux de transport de personnes : Transport en Commun (TC), Voiture Particulière (VP)

=> Modules d’analyse : calcul d'itinéraires TC, VP dans un premier temps, puis à terme de fonctions plus évoluées (accessibilité, etc.)

=> Interfaces (bureautique et internet) Système d’Information géographique (SIG) : pour la visualisation des analyses (itinéraires) et des réseaux de transport modélisés  


====================
CONTENU DE LA FORGE 
====================

- un serveur RAILS qui doit être connecté à une base de données PostGIS, il permet de :
	=> visualiser les données du réseau via une interface web;
	=> créer ou mettre à jour des indicateurs sur les lignes ou les arrêts.
	
- une extension Python pour QGIS, elle permet de :
	=> visusaliser un réseau de transport (lignes et missions);
	=> calculer et visualiser des indicateurs sur les lignes ou les arrêts;
	=> vérifier les connexions avec les serveurs RAILS et PostGIS.

- des données de Test :
	=> le réseau Tatrobus : un réseau simple d'une dizaine de lignes;
	=> le réseau de bus de Toulouse : nous tenons tout particulièrement à remercier la société Tisséo qui nous a aimablement mis à disposition les données de son réseau (90 lignes, plus de 3000 arrêts). A noter cependant que ces données ne doivent être utilisées que dans le cadre de ce démonstrateur, aucune autre utilisation n'est autorisée.

- des scripts sql pour la création de la base de données PostGIS et pour le calcul d'indicateurs.

- documentation :
	=> utilisation, installation et architecture du projet proposé;
	=> comment récupérer et installer la machine virtuelle Ubuntu du projet.
