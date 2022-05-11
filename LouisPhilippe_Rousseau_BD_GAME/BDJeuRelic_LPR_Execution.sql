----Execution-----
use BDjeuRelic;
---groupe 1----
----insertion Armures , Bijoux , Parchemins utilisant les procédures

--5 parchemins
execute ajouterParchemins
@pnumItem = 1,
@pdescription = 'Ceci est un parchemins',
@pnom = 'parchemin01',
@pprix = 10,
@pduree = 100,
@pqteInventaire = 10,
@pqteMin = 1,
@psort = 'meurt',
@pantidote = 0,
@pflagDispo =1;

execute ajouterParchemins
@pnumItem = 2,
@pdescription = 'Ceci est un parchemins',
@pnom = 'parchemin02',
@pprix = 12,
@pduree = 150,
@pqteInventaire = 15,
@pqteMin = 1,
@psort = 'brule',
@pantidote = 2,
@pflagDispo =1;

execute ajouterParchemins
@pnumItem = 3,
@pdescription = 'Ceci est un parchemins',
@pnom = 'parchemin03',
@pprix = 5,
@pduree = 50,
@pqteInventaire = 5,
@pqteMin = 1,
@psort = 'froid',
@pantidote = 1,
@pflagDispo =1;

execute ajouterParchemins
@pnumItem = 4,
@pdescription = 'Ceci est un parchemins',
@pnom = 'parchemin04',
@pprix = 20,
@pduree = 1000,
@pqteInventaire = 3,
@pqteMin = 1,
@psort = 'devenirRiche',
@pantidote = 0,
@pflagDispo =1;

execute ajouterParchemins
@pnumItem = 5,
@pdescription = 'Ceci est un parchemins',
@pnom = 'parchemin05',
@pprix = 2,
@pduree = 200,
@pqteInventaire = 10,
@pqteMin = 1,
@psort = 'vole',
@pantidote = 0,
@pflagDispo = 1;

---5 armures
execute ajouterArmure
@pnumItem = 6,
@pdescription = 'Ceci est un armure',
@pnom = 'Armure01',
@pprix = 5,
@ppoids = 10,
@pflagDispo = 1,
@pqteInventaire = 5,
@pqteMin = 1,
@ptaille = 10,
@pmatiere = 'cuire';

execute ajouterArmure
@pnumItem = 7,
@pdescription = 'Ceci est un armure',
@pnom = 'Armure02',
@pprix = 10,
@ppoids = 30,
@pflagDispo = 1,
@pqteInventaire = 5,
@pqteMin = 1,
@ptaille = 12,
@pmatiere = 'Iron';

execute ajouterArmure
@pnumItem = 8,
@pdescription = 'Ceci est un armure',
@pnom = 'Armure03',
@pprix = 15,
@ppoids = 20,
@pflagDispo = 1,
@pqteInventaire = 5,
@pqteMin = 1,
@ptaille = 13,
@pmatiere = 'Or';

execute ajouterArmure
@pnumItem = 9,
@pdescription = 'Ceci est un armure',
@pnom = 'Armure04',
@pprix = 25,
@ppoids = 25,
@pflagDispo = 1,
@pqteInventaire = 5,
@pqteMin = 1,
@ptaille = 15,
@pmatiere = 'Diamants';

execute ajouterArmure
@pnumItem = 10,
@pdescription = 'Ceci est un armure',
@pnom = 'Armure05',
@pprix = 30,
@ppoids = 20,
@pflagDispo = 1,
@pqteInventaire = 5,
@pqteMin = 1,
@ptaille = 12,
@pmatiere = 'Platinium';

---- 5 Bijoux

execute ajouterBijoux
@pnumItem = 11,
@pnom = 'bague invisibilité',
@pdescription  = 'Qui contre porte cette bague ne se fait pu voire..',
@pqteInventaire = 15,
@pprix = 40,
@pqteMin  = 1,
@pflagDispo  = 1,
@pmatiere = 'Diamond Incrested Gold',
@ptypeBijoux = 'Bague',
@ppouvoirMagique = 'Invisibilité'

execute ajouterBijoux
@pnumItem = 12,
@pnom = 'bague force',
@pdescription  = 'Qui contre porte cette bague devien plus fort(e)..',
@pqteInventaire = 15,
@pprix = 10,
@pqteMin  = 1,
@pflagDispo  = 1,
@pmatiere = 'gold',
@ptypeBijoux = 'Bague',
@ppouvoirMagique = 'force'

execute ajouterBijoux
@pnumItem = 13,
@pnom = 'Bracelet de feu',
@pdescription  = 'Qui contre porte cette bague peut lancer du feu..',
@pqteInventaire = 15,
@pprix = 25,
@pqteMin  = 1,
@pflagDispo  = 1,
@pmatiere = 'Silver',
@ptypeBijoux = 'Bracelet',
@ppouvoirMagique = 'Feu'

execute ajouterBijoux
@pnumItem = 14,
@pnom = 'Collier Enchanté',
@pdescription  = 'Qui contre porte cette bague à plus de magie disponible..',
@pqteInventaire = 15,
@pprix = 5,
@pqteMin  = 1,
@pflagDispo  = 1,
@pmatiere = 'Silver',
@ptypeBijoux = 'Collier',
@ppouvoirMagique = 'Mana'

execute ajouterBijoux
@pnumItem = 15,
@pnom = 'bague Stamina',
@pdescription  = 'Qui contre porte cette bague peut courir longtemps..',
@pqteInventaire = 15,
@pprix = 10,
@pqteMin  = 1,
@pflagDispo  = 1,
@pmatiere = 'Gold',
@ptypeBijoux = 'Bague',
@ppouvoirMagique = 'Stamina'


select * from Items;
select * from Armures;
select * from Parchemins;
select * from Bijoux;

--4----
execute afficherItem
@ptypeItem = 'P';
execute afficherItem
@ptypeItem = 'A';
execute afficherItem
@ptypeItem = 'J';

---5---
select * from prixMoyenItem();
---6---

execute supprimerItem
@pnumItem = 2;

select * from Items;

----groupe 2-----

---1----
select * from Joueurs;
select dbo.MontantPanier('LP');

---2---

execute AjouterItemPanier
@palias  ='LP',
@pqteAchat = 2,
@pnumItem = 15;

---3----
execute modifierItemPanier
@palias = 'LP' , 
@pqteAchat = 3,
@pnumItem = 15;
select * from Paniers;

---4----

execute supprimerItemPanier
@palias = 'LP',
@pnumItem = 15;
select * from Paniers;

---5----
select * from AfficherPanier(500);

--pour le 6 je ne trouve pas pourquoi cela me dit que ppayerItemCursor already exist et qu'il est already open. 
--J'ai mis le close et le deallocate je ne voit pas mon erreur !
---6----
 execute payerPanier
 @palias = 'LP';
 
 ---7---
 execute SupprimerPanier
 @palias = 'LP';

 --devrais marcher mais je ne peut pas payerPanier du a l'erreur au numéro 6(payerPanier)
 ---8---
 select * from afficherAchats('LP');

 --------triggers---------
 ---1---- j'ai réussie a voir l'érreur du trigger avec l'insertion direct dans parchemins,
 --mais quand j'essaie d'inséré correctement un parchemin avec la procédure cela me donne l'erreur de primary key en priorité 
 --(cela m'empeche d'ajouter un item ayant le meme numItem avec le PK dans items) même chose pour Armures
 execute ajouterParchemins
@pnumItem = 10,
@pdescription = 'Ceci est un parchemins',
@pnom = 'parchemin06',
@pprix = 10,
@pduree = 100,
@pqteInventaire = 10,
@pqteMin = 1,
@psort = 'meurtdeuxfoisdesuite',
@pantidote = 0,
@pflagDispo =1;
insert into Parchemins values(10 , 'un sort' , 5 , 'rien');
 ---2----
 ---meme probleme de PK sur items quand j'execute ajouterArmure 
 execute ajouterArmure
@pnumItem = 1,
@pdescription = 'Ceci est un armure',
@pnom = 'Armure06',
@pprix = 30,
@ppoids = 20,
@pflagDispo = 1,
@pqteInventaire = 5,
@pqteMin = 1,
@ptaille = 12,
@pmatiere = 'Platinium';
insert into Armures values(1 , 'steel' , 2 , 2);

---3----
select * from items;
update Items set qteInventaire = 0 where numItem = 1;

---4----
--j'ai tester le trigger en enlevant la même vérification qui étais fait dans la procédure AjouterItemPanier
execute AjouterItemPanier
@palias  ='LP',
@pqteAchat = 2,
@pnumItem = 2;

---5---
execute supprimerItem
@pnumItem = 1;


select * from items;