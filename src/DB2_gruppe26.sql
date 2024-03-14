-- sletter eksisterende tabeller

drop table ForestillingBillett;
drop table HarBillettType;
drop table Billett;
drop table Billettkjop;
drop table Sete;
drop table Rad;
drop table Omrade;
drop table OppsetningAvSkuespill;
drop table Inneholder;
drop table ErTildelt;
drop table DelAv;
drop table Akt;
drop table Spiller;
drop table Forestilling;
drop table Skuespill;
drop table Sal;
drop table Billettype;
drop table SkuespillOppgave;
drop table Skuespiller;
drop table Ansatt;
drop table Kunde;
drop table Rolle;
drop table Forfatter;
drop table Person;

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
	
-- Legger inn data

-- Forfatter

insert into Forfatter (Navn) values ('Henrik Ibsen');
insert into Forfatter (Navn) values ('Jonas Corell Petersen');

-- Sal

insert into Sal (Navn, AntallPlasser) values ('Hovedscenen', 516);
-- bare sette inn ID?^ Skal jo endres dersom SkuespillID endres (eller dette ikke er mulig)
insert into Sal (Navn, AntallPlasser) values ('Gamle scene', 332);
-- samme ^^
insert into Sal (Navn, AntallPlasser) values ('Studioscenen', 150);
insert into Sal (Navn, AntallPlasser) values ('Teaterkjelleren', 60);
insert into Sal (Navn, AntallPlasser) values ('Teaterkafeen', 100);

-- Skuespill

insert into Skuespill (Tittel, Starttid, Varighet, ForfatterID, SalNr) values ('Kongsemnene', '19:00:00', 'Ca. 4 timer inkludert to pauser', (SELECT ForfatterID FROM Forfatter WHERE Navn = 'Henrik Ibsen'), (SELECT SalNr FROM Sal WHERE Navn = 'Hovedscenen'));
insert into Skuespill (Tittel, Starttid, Varighet, ForfatterID, SalNr) values ('Størst av alt er kjærligheten', '18:30:00', 'Ca. 1 time 30 minutter. Spilles uten pause', (SELECT ForfatterID FROM Forfatter WHERE Navn = 'Jonas Corell Petersen'), (SELECT SalNr FROM Sal WHERE Navn = 'Gamle scene'));


-- Område

insert into Omrade (SalNr, Navn) values ((SELECT SalNr FROM Sal WHERE Sal.Navn = 'Hovedscenen'), 'Parkett');
insert into Omrade (SalNr, Navn) values ((SELECT SalNr FROM Sal WHERE Sal.Navn = 'Hovedscenen'), 'Galleri');

insert into Omrade (SalNr, Navn) values ((SELECT SalNr FROM Sal WHERE Sal.Navn = 'Gamle scene'), 'Parkett');
insert into Omrade (SalNr, Navn) values ((SELECT SalNr FROM Sal WHERE Sal.Navn = 'Gamle scene'), 'Balkong');
insert into Omrade (SalNr, Navn) values ((SELECT SalNr FROM Sal WHERE Sal.Navn = 'Gamle scene'), 'Galleri');
-- samme ^^

-- Forestilling

insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-01', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-02', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-03', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-03', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-05', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-06', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-06', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-07', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-12', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-13', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'));
insert into Forestilling (Dato, Skuespill_ID) values ('2024-02-14', (SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'));
-- samme ^^

-- Billettype

insert into Billettype (Typenavn) values ('Ordinær');
insert into Billettype (Typenavn) values ('Honnør');
insert into Billettype (Typenavn) values ('Student');
insert into Billettype (Typenavn) values ('Barn');
insert into Billettype (Typenavn) values ('Gruppe 10');
insert into Billettype (Typenavn) values ('Gruppe honnør 10');

-- HarBillettType
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'), (SELECT TypeID From Billettype WHERE Typenavn = 'Ordinær'), 450);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'), (SELECT TypeID From Billettype WHERE Typenavn = 'Honnør'), 380);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'), (SELECT TypeID From Billettype WHERE Typenavn = 'Student'), 280);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'), (SELECT TypeID From Billettype WHERE Typenavn = 'Gruppe 10'), 420);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Kongsemnene'), (SELECT TypeID From Billettype WHERE Typenavn = 'Gruppe honnør 10'), 360);

insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'), (SELECT TypeID From Billettype WHERE Typenavn = 'Ordinær'), 350);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'), (SELECT TypeID From Billettype WHERE Typenavn = 'Honnør'), 300);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'), (SELECT TypeID From Billettype WHERE Typenavn = 'Student'), 220);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'), (SELECT TypeID From Billettype WHERE Typenavn = 'Barn'), 220);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'), (SELECT TypeID From Billettype WHERE Typenavn = 'Gruppe 10'), 320);
insert into HarBillettType (Skuespill_ID, TypeID, Pris) values ((SELECT Skuespill_ID FROM Skuespill WHERE Skuespill.Tittel = 'Størst av alt er kjærligheten'), (SELECT TypeID From Billettype WHERE Typenavn = 'Gruppe honnør 10'), 270);

-- Person og Skuespiller

-- Skuespillere
-- Kongsemnene
insert into Person (PersonID, Navn) values (1, 'Arturo Scotti');
insert into Person (PersonID, Navn) values (2, 'Ingunn Beate Strige Øyen');
insert into Person (PersonID, Navn) values (3, 'Hans Petter Nilsen');
insert into Person (PersonID, Navn) values (4, 'Madeleine Brandtzæg Nilsen');
insert into Person (PersonID, Navn) values (5, 'Synnøve Fossum Eriksen');
insert into Person (PersonID, Navn) values (6, 'Emma Caroline Deichmann');
insert into Person (PersonID, Navn) values (7, 'Thomas Jensen Takyi');
insert into Person (PersonID, Navn) values (8, 'Per Bogstad Gulliksen');
insert into Person (PersonID, Navn) values (9, 'Isak Holmen Sørensen');
insert into Person (PersonID, Navn) values (10, 'Fabian Heidelberg Lunde');
insert into Person (PersonID, Navn) values (11, 'Emil Olafsson');
insert into Person (PersonID, Navn) values (12, 'Snorre Ryen Tøndel');
-- Størst av alt er kjærligheten
insert into Person (PersonID, Navn) values (13, 'Sunniva Du Mond Nordal');
insert into Person (PersonID, Navn) values (14, 'Jo Saberniak');
insert into Person (PersonID, Navn) values (15, 'Marte M. Steinholt');
insert into Person (PersonID, Navn) values (16, 'Tor Ivar Hagen');
insert into Person (PersonID, Navn) values (17, 'Trond-Ove Skrødal');
insert into Person (PersonID, Navn) values (18, 'Natalie Grøndahl Tangen');
insert into Person (PersonID, Navn) values (19, 'Åsmund Flaten');

-- Kunsteriske lag Kongsemnene
insert into Person (Navn) values ('Yury Butusov');
insert into Person (Navn) values ('Aleksandr Shishkin-Hokusai');
insert into Person (Navn) values ('Eivind Myren');
insert into Person (Navn) values ('Mina Rype Stokke');
/*
-- Produksjonslag Kongsemnene
insert into Person (Navn) values ('Randi Andersen Gafseth');
insert into Person (Navn) values ('Emily F. Luthentun');
insert into Person (Navn) values ('Ann Eli Aasgård');
insert into Person (Navn) values ('Marianne Aunvik');
insert into Person (Navn) values ('Martin Didrichsen');
insert into Person (Navn) values ('Are Skarra Kvitnes');
insert into Person (Navn) values ('Roger Indgul');
insert into Person (Navn) values ('Anders Schille');
insert into Person (Navn) values ('Oliver Løding');
insert into Person (Navn) values ('Harald Soltvedt');
insert into Person (Navn) values ('Karl-Martin Hoddevik');
insert into Person (Navn) values ('Geir Dyrdal');
insert into Person (Navn) values ('Trine Bjørhusdal');
insert into Person (Navn) values ('Renee Desmond');
insert into Person (Navn) values ('Charlotta Winger');
insert into Person (Navn) values ('Egil Buseth');
insert into Person (Navn) values ('Per Arne Johansen');
insert into Person (Navn) values ('Toril Skipnes');
insert into Person (Navn) values ('Anita Gundersen');
*/
-- Kunstnerisk lag Størst av alt er kjærligheten
insert into Person (Navn) values ('Jonas Corell Petersen');
insert into Person (Navn) values ('David Gehrt');
insert into Person (Navn) values ('Gaute Tønder');
insert into Person (Navn) values ('Magnus Mikaelsen');
insert into Person (Navn) values ('Kristoffer Spender');
/*
-- Produksjonslag Størst av alt er kjærligheten (noe overlapp med Kongsemnene legges ikke til på nytt)
insert into Person (Navn) values ('Line Åmli');
insert into Person (Navn) values ('Lars Magnus Krogh Utne');
insert into Person (Navn) values ('Livinger Ferner Diesen');
insert into Person (Navn) values ('Espen Høyem');
insert into Person (Navn) values ('Kjersti Eckhoff');
insert into Person (Navn) values ('Ida Marie Brønstad');
insert into Person (Navn) values ('Jan Magne Høynes');
insert into Person (Navn) values ('Siril Gaare');
insert into Person (Navn) values ('Stein Jørgen Øien');
insert into Person (Navn) values ('Steffen Telstad');
insert into Person (Navn) values ('Erik Chan');
insert into Person (Navn) values ('Olav Rui');
*/
insert into Person (Navn) values ('Elisabeth Egseth Hansen'); -- teaterets direktør / teatersjef


insert into Skuespiller (PersonID) values (1);
insert into Skuespiller (PersonID) values (2);
insert into Skuespiller (PersonID) values (3);
insert into Skuespiller (PersonID) values (4);
insert into Skuespiller (PersonID) values (5);
insert into Skuespiller (PersonID) values (6);
insert into Skuespiller (PersonID) values (7);
insert into Skuespiller (PersonID) values (8);
insert into Skuespiller (PersonID) values (9);
insert into Skuespiller (PersonID) values (10);
insert into Skuespiller (PersonID) values (11);
insert into Skuespiller (PersonID) values (12);
insert into Skuespiller (PersonID) values (13);
insert into Skuespiller (PersonID) values (14);
insert into Skuespiller (PersonID) values (15);
insert into Skuespiller (PersonID) values (16);
insert into Skuespiller (PersonID) values (17);
insert into Skuespiller (PersonID) values (18);
insert into Skuespiller (PersonID) values (19);

insert into Ansatt (PersonID, AnsattStatus) values (20, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (21, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (22, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (23, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (24, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (25, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (26, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (27, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (28, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (29, 'Fast');
/* -- Ansatte i produksjonslag
insert into Ansatt (PersonID, AnsattStatus) values (30, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (31, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (32, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (33, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (34, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (35, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (36, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (37, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (38, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (39, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (40, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (41, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (42, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (43, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (44, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (45, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (46, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (47, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (48, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (49, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (50, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (51, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (52, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (53, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (54, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (55, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (56, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (57, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (58, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (59, 'Fast');
insert into Ansatt (PersonID, AnsattStatus) values (60, 'Fast');
*/

-- Rolle

-- Kongsemnene
insert into Rolle (RolleID, Navn) values (1, 'Haakon Haakonssønn');
insert into Rolle (RolleID, Navn) values (2, 'Inga fra Vartejg'); 
insert into Rolle (RolleID, Navn) values (3, 'Skule jarl');
insert into Rolle (RolleID, Navn) values (4, 'Fru Ragnhild');
insert into Rolle (RolleID, Navn) values (5, 'Margrete');
insert into Rolle (RolleID, Navn) values (6, 'Sigrid');
insert into Rolle (RolleID, Navn) values (7, 'Ingebjørg');
insert into Rolle (RolleID, Navn) values (8, 'Biskop Nikolas');
insert into Rolle (RolleID, Navn) values (9, 'Gregorius Jonssønn');
insert into Rolle (RolleID, Navn) values (10, 'Paal Flida');
insert into Rolle (RolleID, Navn) values (11, 'Baard Bratte');
insert into Rolle (RolleID, Navn) values (12, 'Jatgeir Skald');
insert into Rolle (RolleID, Navn) values (13, 'Dagfinn Bonde');
insert into Rolle (RolleID, Navn) values (14, 'Peter');
-- Størst av alt er kjærligheten
insert into Rolle (RolleID, Navn) values (15, 'Sunniva Du Mond Nordal');
insert into Rolle (RolleID, Navn) values (16, 'Jo Saberniak');
insert into Rolle (RolleID, Navn) values (17, 'Marte M. Steinholt');
insert into Rolle (RolleID, Navn) values (18, 'Tor Ivar Hagen');
insert into Rolle (RolleID, Navn) values (19, 'Trond-Ove Skrødal');
insert into Rolle (RolleID, Navn) values (20, 'Natalie Grøndahl Tangen');
insert into Rolle (RolleID, Navn) values (21, 'Åsmund Flaten');

-- Spiller

insert into Spiller (SkuespillerID, RolleID) values (1, 1);
insert into Spiller (SkuespillerID, RolleID) values (2, 2);
insert into Spiller (SkuespillerID, RolleID) values (3, 3);
insert into Spiller (SkuespillerID, RolleID) values (4, 4);
insert into Spiller (SkuespillerID, RolleID) values (5, 5);
insert into Spiller (SkuespillerID, RolleID) values (6, 6);
insert into Spiller (SkuespillerID, RolleID) values (6, 7);
insert into Spiller (SkuespillerID, RolleID) values (7, 8);
insert into Spiller (SkuespillerID, RolleID) values (8, 9);
insert into Spiller (SkuespillerID, RolleID) values (9, 10);
insert into Spiller (SkuespillerID, RolleID) values (10, 11);
insert into Spiller (SkuespillerID, RolleID) values (11, 12);
insert into Spiller (SkuespillerID, RolleID) values (11, 13);
insert into Spiller (SkuespillerID, RolleID) values (12, 14);
insert into Spiller (SkuespillerID, RolleID) values (13, 15);
insert into Spiller (SkuespillerID, RolleID) values (14, 16);
insert into Spiller (SkuespillerID, RolleID) values (15, 17);
insert into Spiller (SkuespillerID, RolleID) values (16, 18);
insert into Spiller (SkuespillerID, RolleID) values (17, 19);
insert into Spiller (SkuespillerID, RolleID) values (18, 20);
insert into Spiller (SkuespillerID, RolleID) values (19, 21);

-- Akt
insert into Akt (Skuespill_ID, AktNr) values (1, 1);
insert into Akt (Skuespill_ID, AktNr) values (1, 2);
insert into Akt (Skuespill_ID, AktNr) values (1, 3);
insert into Akt (Skuespill_ID, AktNr) values (1, 4);
insert into Akt (Skuespill_ID, AktNr) values (1, 5);

insert into Akt (Skuespill_ID, AktNr) values (2,1);

-- DelAv

insert into DelAv (RolleID, Skuespill_ID, AktNr) values (1, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (1, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (1, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (1, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (1, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (2, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (2, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (3, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (3, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (3, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (3, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (3, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (4, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (4, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (5, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (5, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (5, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (5, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (5, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (6, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (6, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (6, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (7, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (8, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (8, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (8, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (9, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (9, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (9, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (9, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (9, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (10, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (10, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (10, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (10, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (10, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (11, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (11, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (11, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (11, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (11, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (12, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (13, 1, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (13, 1, 2);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (13, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (13, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (13, 1, 5);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (14, 1, 3);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (14, 1, 4);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (14, 1, 5);

insert into DelAv (RolleID, Skuespill_ID, AktNr) values (15, 2, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (16, 2, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (17, 2, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (18, 2, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (19, 2, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (20, 2, 1);
insert into DelAv (RolleID, Skuespill_ID, AktNr) values (21, 2, 1);

-- SkuespillOppgave

insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (1, 'Regissør');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (2, 'Musikkutvelgelse');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (3, 'Scenografi');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (4, 'Kostymeansvarlig');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (5, 'Lysdesign');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (6, 'Dramaturg');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (7, 'Musikalsk ansvarlig');

insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (8, 'Inspisient');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (9, 'Sufflør');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (10, 'Maskeansvarlig');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (11, 'Teknisk koordinator');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (12, 'Lysmester');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (13, 'Lysbordoperatør');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (14, 'Lyddesign');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (15, 'Lydbordoperatør');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (16, 'Rekvisittansvarlig');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (17, 'Sceneansvarlig');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (18, 'Stykkeansvarlig kostyme');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (19, 'Stykkeansvarlig påkledere');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (20, 'Tapetserer');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (21, 'Snekker');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (22, 'Metallarbeider');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (23, 'Malersal');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (24, 'Stykkeansvarlig rekvisitt');
insert into SkuespillOppgave (OppgaveID, Beskrivelse) values (25, 'Videodesign');

-- ErTildelt

insert into ErTildelt (AnsattID, OppgaveID) values (20, 1);
insert into ErTildelt (AnsattID, OppgaveID) values (20, 2);
insert into ErTildelt (AnsattID, OppgaveID) values (21, 3);
insert into ErTildelt (AnsattID, OppgaveID) values (21, 4);
insert into ErTildelt (AnsattID, OppgaveID) values (22, 5);
insert into ErTildelt (AnsattID, OppgaveID) values (23, 6);
insert into ErTildelt (AnsattID, OppgaveID) values (24, 8);
insert into ErTildelt (AnsattID, OppgaveID) values (25, 8);
insert into ErTildelt (AnsattID, OppgaveID) values (26, 9);
insert into ErTildelt (AnsattID, OppgaveID) values (27, 10);
insert into ErTildelt (AnsattID, OppgaveID) values (28, 11);
insert into ErTildelt (AnsattID, OppgaveID) values (29, 12);
/*
insert into ErTildelt (AnsattID, OppgaveID) values (30, 13);
insert into ErTildelt (AnsattID, OppgaveID) values (31, 14);
insert into ErTildelt (AnsattID, OppgaveID) values (32, 15);
insert into ErTildelt (AnsattID, OppgaveID) values (33, 15);
insert into ErTildelt (AnsattID, OppgaveID) values (34, 16);
insert into ErTildelt (AnsattID, OppgaveID) values (35, 17);
insert into ErTildelt (AnsattID, OppgaveID) values (36, 18);
insert into ErTildelt (AnsattID, OppgaveID) values (37, 19);
insert into ErTildelt (AnsattID, OppgaveID) values (38, 20);
insert into ErTildelt (AnsattID, OppgaveID) values (39, 21);
insert into ErTildelt (AnsattID, OppgaveID) values (40, 22);
insert into ErTildelt (AnsattID, OppgaveID) values (41, 23);
insert into ErTildelt (AnsattID, OppgaveID) values (42, 23);
insert into ErTildelt (AnsattID, OppgaveID) values (43, 1);
insert into ErTildelt (AnsattID, OppgaveID) values (44, 3);
insert into ErTildelt (AnsattID, OppgaveID) values (44, 4);
insert into ErTildelt (AnsattID, OppgaveID) values (45, 7);
insert into ErTildelt (AnsattID, OppgaveID) values (46, 5);
insert into ErTildelt (AnsattID, OppgaveID) values (47, 6);
insert into ErTildelt (AnsattID, OppgaveID) values (48, 8);
insert into ErTildelt (AnsattID, OppgaveID) values (49, 9);
insert into ErTildelt (AnsattID, OppgaveID) values (50, 10);
insert into ErTildelt (AnsattID, OppgaveID) values (51, 24);
insert into ErTildelt (AnsattID, OppgaveID) values (52, 18);
insert into ErTildelt (AnsattID, OppgaveID) values (53, 19);
insert into ErTildelt (AnsattID, OppgaveID) values (54, 14);
insert into ErTildelt (AnsattID, OppgaveID) values (55, 14);
insert into ErTildelt (AnsattID, OppgaveID) values (56, 25);
insert into ErTildelt (AnsattID, OppgaveID) values (57, 13);
insert into ErTildelt (AnsattID, OppgaveID) values (58, 17);
insert into ErTildelt (AnsattID, OppgaveID) values (59, 21);
*/
-- Inneholder

insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 1);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 2);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 3);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 4);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 5);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 6);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 8);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 9);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 10);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 11);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 12);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 13);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 14);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 15);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 16);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 17);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 18);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 19);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 20);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 21);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 22);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 23);

insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 1);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 3);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 4);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 5);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 6);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 7);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 8);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 9);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 10);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 24);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 17);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 18);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 13);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 25);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 20);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 21);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 22);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 23);

insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 1, 1);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 2, 2);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 3, 3);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 4, 4);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 5, 5);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 6, 6);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 7, 6);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 8, 7);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 9, 8);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 10, 9);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 11, 10);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 12, 11);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 13, 11);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (1, 14, 12);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (2, 15, 13);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (2, 16, 14);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (2, 17, 15);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (2, 18, 16);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (2, 19, 17);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (2, 20, 18);
insert into OppsetningAvSkuespill(Skuespill_ID, RolleID, SkuespillerID) values (2, 21, 19);
