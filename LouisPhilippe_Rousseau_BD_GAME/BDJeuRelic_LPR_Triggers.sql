use BDjeuRelic;
----groupe 3----
-----1-----
go;
create or alter trigger beforeInsertParchemin on Parchemins AFTER Insert
as
declare 
@pNumItem int;
select @pNumItem = numItem from inserted;

begin
	if(@pNumItem in (select Armures.numItem from Armures) or @pNumItem in (select Bijoux.numItem from Bijoux))
		begin
		rollback;
		raiserror(15600 , -1 , -1 , 'il y a un Armure ou un Bijoux avec le même numéro de item ! impossible de inséré la ligne');
		end
end;

------2-----
go;
create or alter trigger beforeInsertArmure on Armures AFTER Insert
as
declare 
@pNumItem int;
select @pNumItem = numItem from inserted;

begin
	if(@pNumItem in (select Parchemins.numItem from Parchemins) or @pNumItem in (select Bijoux.numItem from Bijoux))
		begin
		rollback;
		raiserror(15600 , -1 , -1 , 'il y a un Parchemin ou un Bijoux avec le même numéro de item ! impossible de inséré la ligne');
		end
end;

----3-----
go;
create or alter trigger updatestockItem on Items after update
as
declare 
@pqteInventaire int,
@pqteMin int,
@pnumItem int;

select @pqteInventaire = qteInventaire from inserted;
select @pqteMin = qteMin from inserted;
select @pnumItem = numItem from inserted;
begin try 
	begin transaction
		if(@pqteInventaire < @pqteMin)
			begin
				update Items set Items.qteInventaire = Items.qteInventaire + @pqteMin * 3 where numItem = @pnumItem ;
			end
	commit;
end try

begin catch
	rollback;
	print ERROR_MESSAGE();
	print ERROR_LINE();
end catch;



----4---
go;
create trigger afterInsertPanier on Paniers after insert
as
declare
@pniveau smallint,
@pIDJoueur int,
@pnumItem int,
@ptypeItem char(1);

select @pIDJoueur = IDJoueur from inserted;
select @pniveau = Joueurs.niveau from Joueurs where IDJoueur = @pIDJoueur;
select @pnumItem = numItem from inserted;
select @ptypeItem = Items.typeItem from Items where Items.numItem = @pnumItem;
begin
	if(@pniveau = 1 and @ptypeItem = 'P')
		begin
			rollback;
			print'Impossible dajouter un parchemins dans le panier dun joueur de niveau !';
		end;
end;
---5----
go;
create trigger cascadeDeleteItem on Items instead of delete
as
declare
@pnumItem int,
@ptypeItem char(1);
select @pnumItem = deleted.numItem from deleted;
select @ptypeItem = Items.typeItem from Items where Items.numItem = @pnumItem;
begin try
	begin transaction
		if(@pnumItem not in(select Historique.numItem from Historique))
			begin
				delete from Paniers where Paniers.numItem = @pnumItem;
				if(@ptypeItem = 'P')
				begin
					delete from Parchemins where Parchemins.numItem = @pnumItem;
				end;
				if(@ptypeItem = 'A')
				begin
					delete from Armures where Armures.numItem = @pnumItem;
				end;
				if(@ptypeItem = 'J')
				begin
					delete from Bijoux where Bijoux.numItem = @pnumItem;
				end;
				delete from Items where Items.numItem = @pnumItem;			
			end;
	commit;
end try

begin catch
	rollback;
	print ERROR_MESSAGE();
	print ERROR_LINE();
end catch

	
