create database BDjeuRelic;

use BDjeuRelic;

drop table Joueurs;
drop table Historiques;
drop table Items;
drop table Armures;
drop table Bijoux;
drop table Paniers;
drop table Parchemins;
drop table Achats;

create table Joueurs
(
IDJoueur int IDENTITY(500,1),
alias varchar(30) UNIQUE NOT NULL,
nom varchar(40),
prenom varchar(40),
solde money,
niveau smallint,
constraint PK_IDJoueur PRIMARY KEY(IDJoueur)
);

create table Items(
numItem int,
nom varchar(30),
description varchar(60),
qteInventaire int,
prix money,
qteMin int,
typeItem char(1),
flagDispo int
constraint CK_flagDispo CHECK(flagDispo = 0 OR flagDispo = 1),
constraint CK_typeItem CHECK(typeItem = 'P' OR typeItem = 'A' OR typeItem = 'J'),
constraint CK_qteInventaire CHECK(qteInventaire >=0),
constraint CK_qteMin CHECK(qteMin >=0),
constraint PK_numItem PRIMARY KEY(numItem)

);

create table Armures(
numItem int ,
matiere varchar(30),
poids int,
taille int,
constraint PK_numItemArmure PRIMARY KEY(numItem),
constraint FK_numItemArmure Foreign key(numItem) references Items(numItem)
);
create table Parchemins(
numItem int,
sort varchar(30),
duree int,
antidote varchar(30),
constraint PK_numItemParchemin PRIMARY KEY(numItem),
constraint FK_numItemParchemin Foreign key(numItem) references Items(numItem)
);
create table Bijoux(
numItem int,
matiere varchar(30),
typeBijoux varchar(30),
pouvoirMagique varchar(30),
constraint PK_numItemBijoux PRIMARY KEY(numItem),
constraint FK_numItemBijoux Foreign key(numItem) references Items(numItem)
);

create table Paniers(
IDJoueur int,
numItem int,
qteAchat int,
constraint PK_IDJoueur_numItem PRIMARY KEY(IDJoueur , numItem),
constraint FK_IDJoueurPanier foreign key(IDJoueur) references Joueurs(IDJoueur),
constraint FK_numItemPanier foreign key(numItem) references Items(numItem)
);

create table Achats(
IDAchat int IDENTITY(1000,1),
dateAchat date,
IDJoueur int,
constraint PK_IDAchat PRIMARY KEY(IDAchat),
constraint fk_IDJoueurAchats foreign key(IDJoueur) references Joueurs(IDJoueur)
);
create table Historique(
IDAchat int,
numItem int,
qtePayee int,
constraint PK_IDAchat_numItem PRIMARY KEY(IDAchat , numItem),
constraint FK_IDAchatHistorique foreign key(IDAchat) references Achats(IDAchat),
constraint FK_numItemHistorique foreign key(numItem) references Items(numItem),
constraint CK_qtePayee CHECK(qtePayee >0)
);

insert into Joueurs values('LP' , 'rousseau' , 'louis-philippe' , 100 , 1);
insert into Joueurs values('JR' , 'Russel' , 'Jack' , 100 , 1);
insert into Joueurs values('goerge' , 'Orwell' , 'goerge' , 100 , 1);
insert into Joueurs values('bobby' , 'Léponge' , 'bob' , 100 , 1);
insert into Joueurs values('MJ' , 'Jordan' , 'Micheal' , 100 , 1);
