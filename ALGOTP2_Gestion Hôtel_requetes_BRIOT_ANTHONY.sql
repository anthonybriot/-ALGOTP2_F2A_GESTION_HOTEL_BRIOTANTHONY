--Nombre de clients
select count(*)
from T_CLIENT
--Les clients triés sur le titre et le nom
select CLI_NOM, CLI_PRENOM, TIT_CODE
from T_CLIENT
order by TIT_CODE, CLI_NOM
--Les clients triés sur le libellé du titre et le nom
select TIT_LIBELLE as "Titre", CLI_NOM as "Nom du client", CLI_PRENOM as "Prenom du client"
from T_TITRE, T_CLIENT
order by "Titre", "Nom du client"
--Les clients commençant par 'B'
select CLI_NOM as "Nom du client"
from T_CLIENT
where upper("Nom du client") like upper ('B%')
--Les clients homonymes
select CLI_NOM
from T_CLIENT
group by (CLI_NOM)
--Nombre de titres différents
select count(TIT_CODE) as "Nombre de titres"
from T_TITRE
--Nombre d'enseignes
select count(CLI_ENSEIGNE) as "Nombre d'enseignes"
from T_CLIENT
--Les clients qui représentent une enseigne 
select CLI_NOM as "Représentant d'enseigne", CLI_ENSEIGNE as "Enseigne"
from T_CLIENT
where CLI_ENSEIGNE like '%'
--Les clients qui représentent une enseigne de transports
select CLI_NOM as "Représentant d'enseigne", CLI_ENSEIGNE as "Enseigne"
from T_CLIENT
where upper("Enseigne") like upper('transports%')
--Nombre d'hommes,Nombres de femmes, de demoiselles, Nombres de sociétés
select count(CLI_ID) as "Monsieur"
from T_CLIENT
where upper(TIT_CODE) like upper ('M.')
--Nombre d''emails
select count(*) 
from T_EMAIL
--Client sans email 
select CLI_NOM as "Client sans adresse mail"
from T_CLIENT as C
where not exists (select EML_ADRESSE from T_EMAIL where CLI_ID = C.CLI_ID)
--Clients sans téléphone 
select CLI_NOM as "Client sans telephone"
from T_CLIENT C
where not exists (select TEL_NUMERO from T_TELEPHONE where CLI_ID = C.CLI_ID)
--Les phones des clients
select T_TELEPHONE.TEL_NUMERO 'Telephone', T_CLIENT.CLI_NOM 'Client'
from T_TELEPHONE,T_CLIENT
where (T_TELEPHONE.CLI_ID=T_CLIENT.CLI_ID)
order by (CLI_NOM)
--Ventilation des phones par catégorie
select TEL_NUMERO "Telephone", TYP_CODE "Ventilation"
from T_TELEPHONE
order by (TYP_CODE) asc
--Les clients ayant plusieurs téléphones
select CLI_NOM
from  T_CLIENT C
where (select count(*)
		from T_TELEPHONE
		where CLI_ID = C.CLI_ID) >1)
--Clients sans adresse:
select CLI_NOM 'Client sans adresse'
from T_CLIENT C
where not exists ( select ADR_LIGNE1 
					from T_ADRESSE 
					where CLI_ID=C.CLI_ID)
--Clients sans adresse mais au moins avec mail ou phone 
select CLI_NOM 'Client sans adresse, mais avec phone ou mail'
from T_CLIENT C
where not exists ( select ADR_LIGNE1 from T_ADRESSE where CLI_ID=C.CLI_ID)
and exists ( select TEL_NUMERO from T_TELEPHONE where CLI_ID=C.CLI_ID)
or exists ( select EML_ADRESSE from T_EMAIL where CLI_ID=C.CLI_ID)
--Dernier tarif renseigné
select *
from T_TARIF
order by TRF_DATE_DEBUT desc LIMIT 1
--Tarif débutant le plus tôt 

--Différentes Années des tarifs
select TRF_DATE_DEBUT 'Différentes années des tarifs'
from T_TARIF
--Nombre de chambres de l'hotel 
select count(*) 'Nombre de chambres'
from T_CHAMBRE
--Nombre de chambres par étage
select count(CHB_ID) 'Nombre de chambres', CHB_ETAGE 'Etage'
from T_CHAMBRE
group by (CHB_ETAGE)
--Chambres sans telephone
select CHB_ID 'Chambres sans téléphone'
from T_CHAMBRE
where not exists (select CHB_POSTE_TEL
                               from T_CHAMBRE)
--Existence d'une chambre n°13 ?
select *
from T_CHAMBRE
where CHB_NUMERO = 13
--Chambres avec sdb
select * 
from T_CHAMBRE
where CHB_BAIN >0
--Chambres avec douche
select * 
from T_CHAMBRE
where CHB_DOUCHE >0
--Chambres avec WC
select *
from T_CHAMBRE
where CHB_WC >0
--Chambres sans WC séparés
select *
from T_CHAMBRE
where CHB_WC =0
--Quels sont les étages qui ont des chambres sans WC séparés ?
select CHB_ETAGE 'Etage sans WC séparés'
from T_CHAMBRE
where exists ( select *
				from T_CHAMBRE
				where CHB_WC =0)
				group by CHB_ETAGE

--Nombre d'équipements sanitaires par chambre trié par ce nombre d'équipement croissant
select abs(CHB_BAIN+CHB_DOUCHE+CHB_WC) 'Nb equipements sanitaires', CHB_NUMERO 'Chambre'
from T_CHAMBRE
order by abs(CHB_BAIN+CHB_DOUCHE+CHB_WC) desc
--Chambres les plus équipées et leur capacité
select abs(CHB_BAIN+CHB_DOUCHE+CHB_WC) 'Nb equipements sanitaires', CHB_NUMERO 'Chambre', CHB_COUCHAGE 'Capacité'
from T_CHAMBRE
where abs(CHB_BAIN+CHB_DOUCHE+CHB_WC)>=3
--Repartition des chambres en fonction du nombre d'équipements et de leur capacité
select CHB_ETAGE 'Etage',abs(CHB_BAIN+CHB_DOUCHE+CHB_WC) 'Nb equipements sanitaires', CHB_NUMERO 'Chambre', CHB_COUCHAGE 'Capacité'
from T_CHAMBRE
--Nombre de clients ayant utilisé une chambre
select count(*) 'nombre de clients ayant utilisés une chambre'
from T_CLIENT C
where exists ( select FAC_ID from T_FACTURE where CLI_ID = C.CLI_ID)
--Clients n'ayant jamais utilisé une chambre (sans facture)
select count(*) 'client nayant jamais utilisé une chambre'
from T_CLIENT C
where not exists ( select FAC_ID from T_FACTURE where CLI_ID = C.CLI_ID)
--Nom et prénom des clients qui ont une facture
select CLI_NOM 'Nom', CLI_PRENOM 'Prenom'
from T_CLIENT C
where  exists ( select FAC_ID from T_FACTURE where CLI_ID = C.CLI_ID)
--Nom, prénom, telephone des clients qui ont une facture
select CLI_NOM 'Nom', CLI_PRENOM 'Prenom', TEL_NUMERO 'Telephone'
from T_CLIENT C, T_TELEPHONE
where  exists ( select FAC_ID from T_FACTURE where CLI_ID = C.CLI_ID)
--Attention si email car pas obligatoire : jointure externe

--Adresse où envoyer factures aux clients
select ADR_LIGNE1 'Adresse de facturation'
from T_ADRESSE
--Répartition des factures par mode de paiement (libellé)
select T_MODE_PAIEMENT.PMT_LIBELLE 'libelle', T_FACTURE.PMT_CODE, T_FACTURE.FAC_ID, T_FACTURE.FAC_DATE, T_FACTURE.FAC_PMT_DATE, T_FACTURE.CLI_ID
from T_MODE_PAIEMENT,T_FACTURE
order by (T_MODE_PAIEMENT.PMT_LIBELLE) asc
--Répartition des factures par mode de paiement 
select PMT_CODE,FAC_ID,FAC_DATE,FAC_PMT_DATE,CLI_ID 
from T_FACTURE
order by PMT_CODE
--Différence entre ces 2 requêtes ? 
La première utilise le PMT_LIBELLE de la table T_MODE_PAIEMENT et la deuxième le PMT_CODE de la table T_FACTURE
--Factures sans mode de paiement 
select * 
from T_FACTURE
where not exists ( select PMT_CODE 
from T_FACTURE 
where PMT_CODE like '%')
--Repartition des factures par Années

--Repartition des clients par ville

--Montant TTC de chaque ligne de facture (avec remises)

--Classement du montant total TTC (avec remises) des factures

--Tarif moyen des chambres par années croissantes

--Tarif moyen des chambres par étage et années croissantes

--Chambre la plus cher et en quelle année

--Chambre la plus cher par année 

--Clasement décroissant des réservation des chambres 

--Classement décroissant des meilleurs clients par nombre de réservations

--Classement des meilleurs clients par le montant total des factures

--Factures payées le jour de leur édition

--Facture dates et Délai entre date de paiement et date d'édition de la facture