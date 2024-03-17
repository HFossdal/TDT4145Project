-- oppretter tabeller

create table Person(
	PersonID	integer,
	Navn		varchar(30) not null,
	Tlf			char(8),
	Epost		varchar(30), 
	Adresse		varchar(30),
	constraint Person_PK primary key (PersonID)
	);
	
create table Kunde(
	PersonID	integer,
	constraint Kunde_PK primary key (PersonID),
	constraint Kunde_FK foreign key (PersonID) references Person(PersonID)
		on update restrict
		on delete cascade
	);

create table Ansatt(
	PersonID		integer,
	AnsattStatus	varchar(30) not null check (AnsattStatus in ('Fast', 'Midlertidig', 'Innleid', 'Statist/Frivillig')), 
	constraint Ansatt_PK primary key (PersonID),
	constraint Ansatt_FK foreign key (PersonID) references Person(PersonID)
		on update restrict
		on delete cascade
	);
	
create table Skuespiller(
	PersonID	integer,
	constraint Skuespiller_PK primary key (PersonID),
	constraint Skuespiller_FK foreign key (PersonID) references Person(PersonID)
		on update restrict
		on delete cascade
	);

create table Rolle(
	RolleID		integer,
	Navn		varchar(30) not null,
	constraint Rolle_PK primary key (RolleID)
	);
	
create table Spiller(
	SkuespillerID	integer,
	RolleID			integer,
	constraint Spiller_PK primary key (SkuespillerID, RolleID),
	constraint Spiller_FK1 foreign key (SkuespillerID) references Skuespiller(PersonID)
		on update restrict
		on delete cascade,
	constraint Spiller_FK2 foreign key (RolleID) references Rolle(RolleID)
		on update restrict
		on delete cascade
	);

create table Forfatter(
	ForfatterID	integer,
	Navn		varchar(30) not null,
	constraint Forfatter_PK primary key (ForfatterID)
	);

create table Skuespill(
	Skuespill_ID	integer,
	Tittel			varchar(30) not null,
	Starttid		time not null,
	Varighet		varchar(45) not null,
	ForfatterID		integer,
	SalNr			integer not null,
	constraint Skuespill_PK primary key (Skuespill_ID),
	constraint Skuespill_FK1 foreign key (ForfatterID) references Forfatter(ForfatterID)
		on update restrict
		on delete set null,
	constraint Skuespill_FK2 foreign key (SalNr) references Sal(SalNr)
		on update restrict
		on delete restrict
	);
	
create table Akt(
	Skuespill_ID	integer,
	AktNr			integer,
	Navn			varchar(30),
	constraint Akt_PK primary key (Skuespill_ID, AktNr),
	constraint AKT_FK foreign key (Skuespill_ID) references Skuespill(Skuespill_ID)
		on update restrict
		on delete cascade
	);

create table DelAv(
	RolleID			integer,
	Skuespill_ID	integer,
	AktNr			integer,
	constraint DelAv_PK primary key (RolleID, Skuespill_ID, AktNr),
	constraint DelAv_FK1 foreign key (RolleID) references Rolle(RolleID)
		on update restrict
		on delete cascade,
	constraint DelAv_FK2 foreign key (Skuespill_ID, AktNr) references Akt(Skuespill_ID, AktNr)
		on update restrict
		on delete cascade
	);

create table SkuespillOppgave(
	OppgaveID	integer,
	Beskrivelse	varchar(45) not null,
	constraint SkuespillOppgave_PK primary key (OppgaveID)
	);
	
create table ErTildelt(
	AnsattID	integer,
	OppgaveID	integer,
	constraint ErTildelt_PK primary key (AnsattID, OppgaveID),
	constraint ErTildelt_FK1 foreign key (AnsattID) references Ansatt(PersonID)
		on update restrict
		on delete cascade,
	constraint ErTildelt_FK2 foreign key (OppgaveID) references SkuespillOppgave(OppgaveID)
		on update restrict
		on delete cascade
	);
	
create table Inneholder(
	Skuespill_ID	integer,
	OppgaveID		integer,
	constraint Inneholder_PK primary key (Skuespill_ID, OppgaveID),
	constraint Inneholder_FK1 foreign key (Skuespill_ID) references Skuespill(Skuespill_ID)
		on update restrict
		on delete cascade,
	constraint Inneholder_FK2 foreign key (OppgaveID) references SkuespillOppgave(OppgaveID)
		on update restrict
		on delete cascade
	);

create table OppsetningAvSkuespill(
	Skuespill_ID	integer,
	RolleID			integer,
	SkuespillerID	integer,
	constraint OppsetningAvSkuespill_PK primary key (Skuespill_ID, RolleID, SkuespillerID),
	constraint OppsetningAvSkuespill_FK1 foreign key (Skuespill_ID) references Skuespill(Skuespill_ID)
		on update restrict
		on delete cascade,
	constraint OppsetningAvSkuespill_FK2 foreign key (RolleID) references Rolle(RolleID)
		on update restrict
		on delete cascade,
	constraint OppsetningAvSkuespill_FK3 foreign key (SkueSpillerID) references Skuespiller(PersonID)
		on update restrict
		on delete cascade
	);
	
create table Forestilling(
	ForestillingID	integer,
	Dato			date not null,
	Skuespill_ID	integer not null,
	constraint Forestilling_PK primary key (ForestillingID),
	constraint Forestilling_FK foreign key (Skuespill_ID) references Skuespill(Skuespill_ID)
		on update restrict
		on delete cascade
	);

create table Sal(
	SalNr			integer,
	Navn			varchar(30) not null,
	AntallPlasser	integer not null,
	constraint Sal_PK primary key (SalNr)
	);
	
create table Omrade(
	SalNr	integer,
	Navn	varchar(30) not null,
	constraint Omrade_PK primary key (SalNr, Navn),
	constraint Omrade_FK foreign key (SalNr) references Sal(SalNr)
		on update restrict
		on delete cascade
	);
	
create table Rad(
	RadID	integer,
	RadNr	integer not null,
	SalNr	integer not null,
	Omradenavn	varchar(30) not null,
	constraint Rad_PK primary key (RadID),
	constraint Rad_FK foreign key (SalNr, Omradenavn) references Omrade(SalNr, Navn)
		on update restrict
		on delete cascade
	);

create table Sete(
	SeteID	integer,
	SeteNr	integer not null,
	RadID	integer not null,
	constraint Sete_PK primary key (SeteID),
	constraint Sete_FK foreign key (RadID) references Rad(RadID)
		on update restrict
		on delete cascade
	);

create table Billettkjop(
	KjopNr	integer,
	Dato	date not null,
	Tid		time not null,
	KundeID	integer not null,
	ForestillingID	integer not null,
	constraint Billettkjop_PK primary key (KjopNr)
	constraint Billettkjop_FK1 foreign key (KundeID) references Kunde(PersonID)
		on update restrict
		on delete cascade,
	constraint Billettkjop_FK2 foreign key (ForestillingID) references Forestilling(ForestillingID)
		on update restrict
		on delete cascade
	);

create table Billettype(
	TypeID	integer,
	Typenavn varchar(30) not null check (Typenavn in ('Ordinær', 'Honnør', 'Student', 'Barn', 'Gruppe 10', 'Gruppe honnør 10')),
	constraint Billettype_PK primary key (TypeID)
	);
	
create table Billett(
	BillettID	integer,
	TypeID		integer not null,
	KjopNr		integer not null,
	constraint Billett_PK primary key (BillettID),
	constraint Billett_FK1 foreign key (TypeID) references Billettype(TypeID)
		on update restrict
		on delete cascade,
	constraint Billett_FK2 foreign key (KjopNr) references Billettkjop(KjopNr)
		on update restrict
		on delete cascade
	);
	
create table HarBillettType(
	Skuespill_ID	integer,
	TypeID			integer,
	Pris			integer not null,
	constraint HarBillettType_PK primary key (Skuespill_ID, TypeID),
	constraint HarBillettType_FK1 foreign key (Skuespill_ID) references Skuespill(Skuespill_ID)
		on update restrict
		on delete cascade,
	constraint HarBillettType_FK2 foreign key (TypeID) references Billettype(TypeID)
		on update restrict
		on delete cascade
	);

create table ForestillingBillett(
	ForestillingID	integer,
	BillettID		integer,
	SeteID			integer,
	constraint ForestillingBillett_PK primary key (ForestillingID, BillettID, SeteID),
	constraint ForestillingBillett_FK1 foreign key (ForestillingID) references Forestilling(ForestillingID)
		on update restrict
		on delete cascade,
	constraint ForestillingBillett_FK2 foreign key (BillettID) references Billett(BillettID)
		on update restrict
		on delete cascade,
	constraint ForestillingBillett_FK3 foreign key (SeteID) references Sete(SeteID)
		on update restrict
		on delete cascade
	);