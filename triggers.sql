ALTER TABLE Oeuvre ADD CONSTRAINT ch_1 check (Type in ('EP', 'Album', 'Single'));

ALTER TABLE NominationArtiste ADD CONSTRAINT ch_2 check (Status in (null, 'Gagnant'));

ALTER TABLE NominationGroupe ADD CONSTRAINT ch_3 check (Status in (null, 'Gagnant'));

ALTER TABLE NominationOeuvre ADD CONSTRAINT ch_4 check (Status in (null, 'Gagnant'));

ALTER TABLE Artiste ADD CONSTRAINT ch_contratArt check (DebContrat < FinContrat);

ALTER TABLE Groupe ADD CONSTRAINT ch_contratGr check (DebContrat < FinContrat);

create view publicArtiste (Nom, Nationalite, Instrument)
    as 
       select Nom, Nationalite,Instrument
       from Artiste


