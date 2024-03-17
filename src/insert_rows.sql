-- Legger inn data

-- Forfatter

insert into Forfatter (Navn) values ('Henrik Ibsen');
insert into Forfatter (Navn) values ('Jonas Corell Petersen');

-- Sal

insert into Sal (Navn, AntallPlasser) values ('Hovedscenen', 516);
insert into Sal (Navn, AntallPlasser) values ('Gamle scene', 332);
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

-- Kunsterisk lag Kongsemnene
insert into Person (Navn) values ('Yury Butusov');
insert into Person (Navn) values ('Aleksandr Shishkin-Hokusai');
insert into Person (Navn) values ('Eivind Myren');
insert into Person (Navn) values ('Mina Rype Stokke');

-- Kunstnerisk lag Størst av alt er kjærligheten
insert into Person (Navn) values ('Jonas Corell Petersen');
insert into Person (Navn) values ('David Gehrt');
insert into Person (Navn) values ('Gaute Tønder');
insert into Person (Navn) values ('Magnus Mikaelsen');
insert into Person (Navn) values ('Kristoffer Spender');

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

-- ErTildelt

insert into ErTildelt (AnsattID, OppgaveID) values (20, 1);
insert into ErTildelt (AnsattID, OppgaveID) values (20, 2);
insert into ErTildelt (AnsattID, OppgaveID) values (21, 3);
insert into ErTildelt (AnsattID, OppgaveID) values (21, 4);
insert into ErTildelt (AnsattID, OppgaveID) values (22, 5);
insert into ErTildelt (AnsattID, OppgaveID) values (23, 6);
insert into ErTildelt (AnsattID, OppgaveID) values (24, 1);
insert into ErTildelt (AnsattID, OppgaveID) values (25, 3);
insert into ErTildelt (AnsattID, OppgaveID) values (25, 4);
insert into ErTildelt (AnsattID, OppgaveID) values (26, 7);
insert into ErTildelt (AnsattID, OppgaveID) values (27, 5);
insert into ErTildelt (AnsattID, OppgaveID) values (28, 6);


-- Inneholder

insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 1);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 2);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 3);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 4);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 5);
insert into Inneholder (Skuespill_ID, OppgaveID) values (1, 6);

insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 1);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 3);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 4);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 5);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 6);
insert into Inneholder (Skuespill_ID, OppgaveID) values (2, 7);

-- OppsetningAvSkuespill

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
