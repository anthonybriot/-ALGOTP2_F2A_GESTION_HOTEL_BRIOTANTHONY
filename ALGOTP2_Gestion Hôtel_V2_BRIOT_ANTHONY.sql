Create schema GESTION_HOTEL;

Create table T_CHAMBRE (
		CHB_ID integer  not null,
		CHB_NUMERO smallint not null,
		CHB_ETAGE char(3) not null,
		CHB_BAIN integer(1) not null,
        CHB_DOUCHE integer(1) not null,
        CHB_WC integer(1) not null,
        CHB_COUCHAGE smallint not null,
        CHB_POSTE_TEL char(3) not null,
Primary key (CHB_ID));


Create table T_PLANNING (
		PLN_JOUR date not null,
		primary key (PLN_JOUR));
		

Create table T_TARIF (
		TRF_DATE_DEBUT date not null,
		TRF_TAUX_TAXES real,
		TRF_PETIT_DEJEUNE real,
		primary key(TRF_DATE_DEBUT));
		
		
Create table TJ_TRF_CHB (
		CHB_ID   integer not null,
		TRF_DATE_DEBUT date not null,
		TRF_CHB_PRIX   numeric(8,2) not null,
		primary key (CHB_ID),
		foreign key(CHB_ID) references T_CHAMBRE);

Create table T_TITRE (
		TIT_CODE char(8) not null,
		TIT_LIBELLE char(32) not null,
		primary key(TIT_CODE));
		
Create table T_CLIENT (
		CLI_ID integer not null,
		TIT_CODE char(8) not null,
		CLI_NOM char(32) not null,
		CLI_PRENOM char(25) not null,
		CLI_ENSEIGNE char(100) not null,
		primary key(CLI_ID),
		foreign key (TIT_CODE) references T_TITRE);
		
Create table TJ_CHB_PLN_CLI	(
		CHB_ID integer not null,
		PLN_JOUR date not null,
		CLI_ID integer not null,
		CHB_PLN_CLI_NB_PERS smallint not null,
		CHB_PLN_CLI_RESERVE integer (1) not null,
		CHB_PLN_CLI_OCCUPE integer(1) not null,
		primary key(CHB_ID),
		foreign key (CHB_ID) references T_CHAMBRE
		foreign key(PLN_JOUR) references T_PLANNING
		foreign key (CLI_ID) references T_CLIENT);

Create table T_ADRESSE	(
		ADR_ID integer not null,
		CLI_ID integer not null,
		ADR_LIGNE1 char(32) not null,
		ADR_LIGNE2 char(32),
		ADR_LIGNE3 char(32),
		ADR_LIGNE4 char(32),
		ADR_CP char(5) not null,
		ADR_VILLE char(32) not null,
		primary key (ADR_ID),
		foreign key (CLI_ID) references T_CLIENT);
		
Create table T_EMAIL	(
		EML_ID integer not null,
		CLI_ID integer not null,
		EML_ADRESSE char(100) not null,
		EML_LOCALISATION char(64),
		primary key (EML_ID),
		foreign key (CLI_ID) references T_CLIENT);
		
Create table T_TYPE	(
		TYP_CODE char(8) not null,
		TYP_LIBELLE char(32) not null,
		primary key (TYP_CODE));
		
Create table T_TELEPHONE (
		TEL_ID integer not null,
		CLI_ID integer not null,
		TYP_CODE char(8) not null,
		TEL_NUMERO char(20) not null,
		TEL_LOCALISATION char(64) not null,
		primary key (TEL_ID),
		foreign key (CLI_ID) references T_CLIENT,
		foreign key (TYPE_CODE) references T_TYPE);
		
Create table T_FACTURE (
		FAC_ID integer not null,
		CLI_ID integer not null,
		PMT_CODE char(8) not null,
		FAC_DATE date not null,
		FAC_PMT_DATE date not null
		primary key (FAC_ID),
		foreign key (CLI_ID) references T_FACTURE);
		
Create table T_LIGNE_FACTURES (
		LIF_ID integer not null,
		FAC_ID integer not null,
		LIF_QTE real not null,
		LIF_REMISE_POURCENT real,
		LIF_REMISE_MONTANT real,
		LIF_MONTANT real not null,
		LIF_TAUX_TVA real,
		primary key(LIF_ID),
		foreign key (FAC_ID) references T_FACTURE);
		
Create table T_MODE_PAIEMENT (
		PMT_CODE char(8) not null,
		PMT_LIBELLE char(64) not null,
		primary key (PMT_CODE));
		
		

		
		
		
		
		
		
