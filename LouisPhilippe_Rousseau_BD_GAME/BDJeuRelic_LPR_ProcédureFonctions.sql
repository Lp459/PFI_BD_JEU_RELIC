use BDjeuRelic;
---------------- GROUPE 1--------------------------------
---1---ajouterArmure
go;
create or alter procedure ajouterArmure(
@pnumItem int,
@pnom varchar(30),
@pdescription varchar(60),
@pqteInventaire int,
@pprix money,
@pqteMin int,
@pflagDispo int,
@pmatiere varchar(30),
@ppoids int,
@ptaille int)
as
begin try
	begin transaction
		insert into Items values(@pnumItem , 
								@pnom , 
								@pdescription ,
								@pqteInventaire ,
								@pprix ,
								@pqteMin ,
								'A' ,
								@pflagDispo);

		insert into Armures values(@pnumItem , @pmatiere , @ppoids , @ptaille);
	commit;
end try
begin catch
rollback;
end catch
------2-----AjouterBijoux
go;
create or alter procedure ajouterBijoux(
@pnumItem int,
@pnom varchar(30),
@pdescription varchar(60),
@pqteInventaire int,
@pprix money,
@pqteMin int,
@pflagDispo int,
@pmatiere varchar(30),
@ptypeBijoux varchar(30),
@ppouvoirMagique varchar(30))
as
begin try
	begin transaction
		insert into Items values(@pnumItem , 
								@pnom , 
								@pdescription ,
								@pqteInventaire ,
								@pprix ,
								@pqteMin ,
								'J' ,
								@pflagDispo);

		insert into Bijoux values(@pnumItem , @pmatiere , @ptypeBijoux , @ppouvoirMagique);
	commit;
end try
begin catch
rollback;
end catch

------3-----AjouterParchemins
go;
create or alter procedure ajouterParchemins(
@pnumItem int,
@pnom varchar(30),
@pdescription varchar(60),
@pqteInventaire int,
@pprix money,
@pqteMin int,
@pflagDispo int,
@psort varchar(30),
@pduree int,
@pantidote int)
as
begin try
	begin transaction
		insert into Items values(@pnumItem , 
								@pnom , 
								@pdescription ,
								@pqteInventaire ,
								@pprix ,
								@pqteMin ,
								'P' ,
								@pflagDispo);

		insert into Parchemins values(@pnumItem , @psort , @pduree , @pantidote);
	commit;
end try
begin catch
rollback;
print ERROR_MESSAGE();
print ERROR_LINE();
end catch;

--------4---------AfficherItem

go;

create or alter view ParcheminsView as
select nom ,  qteInventaire , prix , Parchemins.antidote , Parchemins.duree , Parchemins.sort
from Items inner join Parchemins on Items.numItem = Parchemins.numItem 
where typeItem = 'P';

go;
create or alter  view BijouxView as
select nom ,  qteInventaire , prix , Bijoux.matiere , Bijoux.pouvoirMagique , Bijoux.typeBijoux
from Items inner join Bijoux on Items.numItem = Bijoux.numItem 
where typeItem = 'J';

go;
create or alter view ArmureView as
select nom ,  qteInventaire , prix , Armures.matiere , Armures.poids , Armures.taille
from Items inner join Armures on Armures.numItem = Armures.numItem 
where typeItem = 'A';

go;
create or alter procedure afficherItem(@ptypeItem char(1))
as
begin
	if(@ptypeItem = 'P')
		select * from ParcheminsView;
	else if(@ptypeItem = 'J')
		select * from BijouxView;
	else if(@ptypeItem = 'A')
		select * from ArmureView;
end;

drop procedure afficherItem;

--------5------- prixMoyenItem
go;
create or alter function prixMoyenItem () Returns Table
as
RETURN(
		
		select AVG(prix) as PrixMoyen , Items.typeItem  from Items group by typeItem
		);
go;

-----6----------supprimerItem
go;
create or alter procedure supprimerItem(@pnumItem int)
as
begin try
	begin transaction
		if(@pnumItem in (select Paniers.numItem from Paniers))
		begin
			delete from Paniers where Paniers.numitem = @pnumItem;
		end;

		Update Items set flagDispo = 0 where numItem = @pnumItem;
	commit;
end try
begin catch
rollback;
end catch

-----Groupe 2------
----1------
go;
create or alter function MontantPanier(@paliass varchar(30))RETURNS money
as
begin
declare 
@pnumItem int,
@pidJoueur int,
@pprixTotal money;

select @pidJoueur = Joueurs.IDJoueur from Joueurs 
					where alias = @paliass;
select @pnumItem = Paniers.numItem from Paniers where IDJoueur = @pidJoueur;
select @pprixTotal = Items.prix * Paniers.qteAchat from Items 
					 inner join Paniers on Items.numItem = Paniers.numItem 
					 where Paniers.numItem = @pnumItem and Paniers.IDJoueur = @pidJoueur;
return @pprixTotal;
end;

------2-------
go;
create or alter procedure AjouterItemPanier(@palias varchar(30) , @pqteAchat int , @pnumItem int)
as
begin
declare 
@pIDJoueur int,
@pqteInventaire int ,
@psoldeJoueur money ,
@ptypeItem char(1) ,
@pniveau smallint , 
@pprix money,
@pprixTotal money;

select @pIDJoueur = Joueurs.IDJoueur from Joueurs where Joueurs.alias = @palias;
select @pqteInventaire = Items.qteInventaire from Items where Items.numItem = @pnumItem;
select @psoldeJoueur = Joueurs.solde from Joueurs where Joueurs.IDJoueur = @pIDJoueur;
select @ptypeItem = Items.typeItem from Items where Items.numItem = @pnumItem;
select @pniveau = Joueurs.niveau from Joueurs where Joueurs.IDJoueur = @pIDJoueur;
select @pprix = prix from Items where numItem = @pnumItem
select @pprixTotal = @pprix * @pqteAchat;

	
	if(@pIDJoueur not in (select Joueurs.IDJoueur from Joueurs where alias = @palias))
	begin
	print 'Joueur introuvable';
	return;
	end
	if(@ptypeItem = 'P' and @pniveau = 1) 
	begin
	print 'Le joueur ne peut pas acheter de parchemins'
	return;
	end
	if(@pqteInventaire < @pqteAchat) 
	begin;
	print 'qté insuffisante'; 
	return;
	end
	if(@psoldeJoueur <@pprixTotal)
	begin
	print 'Solde du joueur insuffisante'
	return;
	end
begin try
	begin transaction
		if(@pnumItem not in (select Paniers.numItem from Paniers where Paniers.IDJoueur = @pIDJoueur))
		begin
			insert into Paniers values(@pIDJoueur , @pnumItem , @pqteAchat);
			Update Items set Items.qteInventaire = Items.qteInventaire - @pqteAchat where Items.numItem = @pnumItem;
		end
		else
		begin
			update Paniers set qteAchat = qteAchat + @pqteAchat where Paniers.IDJoueur = @pIDJoueur and Paniers.numItem = @pnumItem;
			Update Items set Items.qteInventaire = Items.qteInventaire - @pqteAchat where Items.numItem = @pnumItem;
		end
	commit;
end try
begin catch
rollback;
print ERROR_LINE();
print ERROR_MESSAGE();
end catch
end

----3----
go;
create or alter procedure modifierItemPanier(@palias varchar(30) , @pqteAchat int , @pnumItem int)
as 
declare 
@pqteInventaire int,
@pIDJoueur int;
select @pIDJoueur = Joueurs.IDJoueur from Joueurs where alias = @palias;
select @pqteInventaire = Items.qteInventaire from Items where numItem = @pnumItem;

if(@pIDJoueur not in(select Paniers.IDJoueur from Paniers where Paniers.numItem = @pnumItem))
begin
	print'Impossible de modifier le panier , pas de cette item dans le panier du joueur';
	return;
end
if(@pqteInventaire <@pqteAchat)
	begin
		print'Quantité insuffisante!';
		return;
	end
begin try
	begin transaction
		update Paniers set qteAchat = qteAchat + @pqteAchat where Paniers.IDJoueur = @pIDJoueur and Paniers.numItem = @pnumItem;
		update Items set qteInventaire = qteInventaire - @pqteAchat where numItem = @pnumItem;
	commit;
end try
begin catch
	rollback;
	print ERROR_MESSAGE();
	print ERROR_LINE();
end catch

---4----
go;
create or alter procedure supprimerItemPanier(@palias varchar(30) , @pnumItem int)
as
declare 
@pIDJoueur int,
@pqteAchat int;

select @pIDJoueur = Joueurs.IDJoueur from Joueurs where alias = @palias;
select @pqteAchat = Paniers.qteAchat from Paniers where Paniers.IDJoueur = @pIDJoueur and Paniers.numItem = @pnumItem;

if(@pIDJoueur not in(select Paniers.IDJoueur from Paniers where Paniers.numItem = @pnumItem))
begin
	print'Impossible de supprimer le panier , pas de cette item dans le panier du joueur';
	return;
end
begin try
	begin transaction 
		delete from Paniers where Paniers.IDJoueur = @pIDJoueur and Paniers.numItem = @pnumItem;
		update Items set Items.qteInventaire = qteInventaire + @pqteAchat where Items.numItem = @pnumItem;
	commit;
end try

begin catch
	rollback
	print ERROR_LINE();
	print ERROR_MESSAGE();
end catch

-----5------
go;
create or alter function AfficherPanier(@pIDJoueur int)RETURNS TABLE
as 
RETURN(
		select Items.nom , case Items.typeItem
							when 'A' then 'Armures'
							when 'J' then 'Bijoux'
							when 'P' then 'Parchemins'
							end as typeItem
		, Paniers.qteAchat , Items.prix * Paniers.qteAchat as PrixTotale
		from Paniers inner join Items on Paniers.numItem=Items.numItem 
		where Paniers.IDJoueur = @pIDJoueur
);
	
----6----
go;
create or alter procedure payerPanier(@palias varchar(30))
as 
declare 
@pIDJoueur int,
@pIDAchat int,
@pDateAchat date,
@pNumItem int,
@pQtePayer int,
@pQteAchat int,
@psolde money;
select @pIDJoueur = Joueurs.IDJoueur from Joueurs where alias = @palias;
DECLARE  ppayerItemCursor CURSOR
FOR SELECT 
        Paniers.numItem , 
		Paniers.qteAchat
    FROM 
        Paniers
	where 
		Paniers.IDJoueur = @pIDJoueur;
select @pDateAchat = GETDATE();
select @psolde = solde from Joueurs where IDJoueur = @pIDJoueur;
if(@pIDJoueur not in(select Paniers.IDJoueur from Paniers))
begin
	print'Impossible de payer le panier , pas de panier pour ce joueur';
	return;
end
Begin try
	Begin transaction
		open ppayerItemCursor;
		fetch next from ppayerItemCursor into @pNumItem,@pqteAchat;
		while(@@FETCH_STATUS = 0)
			begin
				select @pQtePayer = prix * @pQteAchat from Items where numItem = @pNumItem;
			if(@psolde > @pQtePayer)
				begin
					Insert into Achats values(@pDateAchat , @pIDJoueur);
					select @pIDAchat = @@IDENTITY from Achats;
					Insert into Historique values(@pIDAchat , @pNumItem , @pQtePayer);
					update Joueurs set Joueurs.solde = Joueurs.solde - @pQtePayer;
				end;
				fetch next from ppayerItemCursor into @pNumItem,@pqteAchat;
			end;
		Delete from Paniers where Paniers.IDJoueur = @pIDJoueur and Paniers.numItem = @pNumItem;
		close ppayerItemCursor;
		DEALLOCATE ppayerItemCursor;
	commit;
end try

begin catch
	rollback;
	print ERROR_MESSAGE();
	print ERROR_LINE();
end catch

----7----
go;
create or alter procedure SupprimerPanier(@palias varchar(30))
as
declare 
@pQteAcheter int,
@pNumItem int,
@pIDJoueur int;
select @pIDJoueur = Joueurs.IDJoueur from Joueurs where alias = @palias;

DECLARE  supprimerItemCursor CURSOR
FOR SELECT Paniers.numItem , Paniers.qteAchat
FROM Paniers
where Paniers.IDJoueur = @pIDJoueur;
if(@pIDJoueur not in(select Paniers.IDJoueur from Paniers))
begin
	print'Impossible de payer le panier , pas de cette item dans le panier du joueur';
	return;
end
	begin try
		begin transaction
			open supprimerItemCursor;
			fetch next from supprimerItemCursor into @pNumItem,@pQteAcheter;
			while(@@FETCH_STATUS = 0)
			begin
				update Items set Items.qteInventaire = Items.qteInventaire + @pQteAcheter where Items.numItem = @pNumItem;
				fetch next from supprimerItemCursor into @pNumItem,@pQteAcheter;
			end;
			delete from Paniers where Paniers.IDJoueur = @pIDJoueur;
			close supprimerItemCursor;
			DEALLOCATE supprimerItemCursor;
		commit;

	end try

	begin catch
	rollback;
	print ERROR_MESSAGE();
	print ERROR_LINE();
	end catch

---8----

go;
create or alter function afficherAchats(@palias varchar(30)) RETURNS TABLE
as
RETURN(
	select Joueurs.alias , Items.nom , Items.typeItem , Historique.qtePayee from Historique inner join
	Items on Historique.numItem = Items.numItem inner join Achats on Historique.IDAchat = Achats.IDAchat 
	inner join Joueurs on Joueurs.IDJoueur = Achats.IDJoueur
	);
