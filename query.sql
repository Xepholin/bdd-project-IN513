-- Quel est l'âge moyen des artistes supervisés par le label ? 

SELECT AVG(MONTHS_BETWEEN(SYSDATE,Naissance)/12)
FROM Artiste;


-- Combien de groupes de Rock la maison de disque a-t-elle engagé en 2019 ?

SELECT nomGenre,nomGroupe
FROM GroupeAppartientAuGenre
WHERE nomGenre = 'Rock' ;

-- Quel artiste a été nominé pour « Meilleur artiste » en 2015 ? 

SELECT NomArtiste, titrePrix
FROM NominationArtiste
WHERE titrePrix = 'Meilleur artiste' ;

-- Combien d'artistes ont plus de 30 ans ?      

SELECT Count(NomdeScene) "Total"
FROM Artiste WHERE floor(MONTHS_BETWEEN(SYSDATE, Naissance) / 12)  >  30;

-- Quel artiste a gagné un prix en 2020 ? 

SELECT NomArtiste, titrePrix
FROM NominationArtiste
WHERE Statut = 'Gagnant'
AND EXTRACT(YEAR FROM dateDeNomination) = '2020';


-- Quels sont les groupes qui se sont séparés l'année dernière? 

SELECT NomGrp, DateSeparation
FROM Groupe
WHERE DateSeparation between '01-jan-2020' and '31-dec-2020';

-- Quels sont les morceaux qui durent plus de 4 minutes et 30 secondes ? 

SELECT titre, Duree
FROM Morceau
WHERE Duree > 270;

-- En quelle année l'artiste recherché a-t-il/elle sorti un EP ? 

SELECT Nom,dateDeSortie
FROM Oeuvre
WHERE Type = 'EP'
AND nomArtiste = '&nomArtiste';

-- Quels sont les artistes qui ont signé un contrat entre 1990 et 2015 ? 

SELECT NomdeScene, DebContrat
FROM Artiste
WHERE DebContrat between '01-jan-1990' and '31-dec-2015';

-- Quelles sont les œuvres qui ont remporté des nominations en 2021 ? 

SELECT O.Nom, N.TitrePrix
FROM NominationOeuvre N, Oeuvre O
WHERE N.dateDeNomination between '01-jan-2021' 
AND '31-dec-2021' AND N.ReferenceOeuvre = O.Reference;

-- Combien d'albums comportent plus de 15 pistes ?

SET serveroutput ON;
DECLARE
    tmp Number;
BEGIN

    SELECT Count(Reference) "Total" into tmp
    FROM Oeuvre O, Morceau M, PisteOeuvre P
    WHERE O.Type = 'Album'
    AND P.ReferenceOeuvre = O.Reference
    AND P.titreMorceau = M.Titre
    AND P.numeroDePiste = 16;
    
    IF (tmp > 0) THEN
        dbms_output.put_line('Il y a ' || tmp || ' albums qui possedent plus de 15 pistes');
    ELSE
        dbms_output.put_line('Il n y a pas d album qui possèdent plus de 15 pistes');
    END IF;

END;
/

-- À combien s'élève le bénéfice total de la maison de disques en 2015 ? 

SELECT SUM(Benefice)
FROM Oeuvre
WHERE dateDeSortie between '01-jan-2015' and '31-dec-2015';

-- Quels sont les noms des artistes nés entre mars 1990 et mai 1999 ?  

SELECT NomdeScene, Naissance
FROM Artiste
WHERE Naissance between '01-mar-1990' and '31-may-1999';

-- Quels sont les artistes français ayant reçu une nomination ? 

SELECT NA.NomArtiste, NA.IdNomination, NA.dateDeNomination, A.Nationalite
FROM NominationArtiste NA,Artiste A
WHERE A.Nationalite = 'Francaise'
AND NA.NomArtiste = A.NomdeScene;

-- Quels sont les prix des œuvres produites par [Nom d'un producteur] ? 

SELECT Nom, Reference, Benefice
FROM Oeuvre
WHERE Producteur = '&Producteur';

-- Quels sont les noms des musiciens jouant de la batterie ? 

SELECT NomdeScene, Nom
FROM Artiste
WHERE Instrument = 'Batterie';

-- Quelles sont les collaborations qui ont eu lieu entre juin et septembre 2019 ?

SELECT O.Nom, O.dateDeSortie
FROM CollaborationArtiste C, Oeuvre O, PisteOeuvre P
WHERE O.dateDeSortie between '01-jun-2019' and '30-sep-2019'
AND P.titreMorceau = C.titreMorceau
AND O.Reference = P.ReferenceOeuvre;

-- Quels sont les noms des artistes appartenant au groupe [Nom du groupe] ? 

SELECT nomArtiste
    FROM MembreduGroupe
    WHERE nomGroupe = '&nomGroupe';

-- Quels sont les albums produits par un groupe américain ?

SELECT o.Nom,o.nomGroupe
FROM Oeuvre o, Groupe g
WHERE o.Type = 'Album'
AND g.Nationalite = 'Americaine'
AND g.NomGrp = o.nomGroupe;

-- Quels sont les artistes appartenant à un groupe qui possède une nomination pour une œuvre sortie entre 1985 et 2020 ?

SELECT distinct MembreDuGroupe.nomArtiste
FROM MembreDuGroupe,(SELECT Groupe.nomGrp as nomGroupe
             FROM Groupe,Oeuvre
             WHERE Oeuvre.dateDeSortie >= '01-jan-1985' AND Oeuvre.dateDeSortie <= '31-dec-2020' AND Oeuvre.nomGroupe=Groupe.nomGrp)Groupes
WHERE MembreDuGroupe.nomGroupe=Groupes.nomGroupe;


-- Quels artistes ont collaboré avec [Nom d'un artiste] ?

SELECT distinct nomArtiste
FROM CollaborationArtiste k,(SELECT NomDeScene as Name
                    FROM Artiste
                    WHERE NomDeScene = '&nomArtiste')ArtisteCollab
WHERE k.TitreMorceau IN(SELECT TitreMorceau
            FROM CollaborationArtiste c
            WHERE c.nomArtiste=ArtisteCollab.Name)
AND k.nomArtiste != ArtisteCollab.Name    
;

-- Quels producteurs ont travaillé sur une œuvre qui a reçu une nomination pour « Meilleur Album» ?

SELECT distinct Oeuvre.Producteur
FROM Oeuvre,NominationOeuvre
WHERE Oeuvre.reference=NominationOeuvre.reference
AND NominationOeuvre.TitrePrix ='Meilleur Album';

-- Quels artistes ont participé à la création d'un album ayant plus de 5 pistes ?

SELECT distinct a.NomDeScene
FROM Artiste a,Oeuvre o
WHERE (o.Type='Album' AND a.NomDeScene=o.nomArtiste AND (SELECT max(NumeroDePiste)
            FROM PisteOeuvre p
            WHERE p.ReferenceOeuvre = o.reference) > 5)
OR a.NomDeScene in (SELECT  v.NomArtiste
            FROM MembreDuGroupe v,(SELECT g.NomGrp as nomgroupe
                      FROM Groupe g,Oeuvre n
                      WHERE (n.Type='Album' AND g.nomGrp=n.nomGroupe AND (SELECT max(NumeroDePiste)
                                                FROM PisteOeuvre p
                                                WHERE p.ReferenceOeuvre = n.reference) > 5))groupes
            WHERE v.nomGroupe=groupes.nomgroupe);
;

-- Quels morceaux, ayant une durée supérieure à 2:30, ont obtenu une nomination ?

SELECT m.titre, o.Nom
FROM morceau m, oeuvre o, pisteOeuvre p
WHERE m.Duree >= 150
AND m.titre = p.titremorceau
AND p.referenceoeuvre = o.reference
AND o.reference in (SELECT distinct ReferenceOeuvre 
            FROM NominationOeuvre);
;

-- Quels sont les artistes ayant travaillé pour la réalisation du single [Nom d'un titre]?

SELECT NomArtiste
FROM Oeuvre
WHERE type = 'Single'
AND Nom = '&Nom';

-- Quelles œuvres, qui ont déjà été nominé entre 1980 et 1999, ont été nominé entre 2000 et 2010 ?

SELECT distinct q.Nom
FROM Oeuvre q,NominationOeuvre n
WHERE n.dateDeNomination >= '01-jan-1980' AND n.dateDeNomination <= '31-dec-1999'
AND q.reference=n.referenceOeuvre
AND q.Nom in(SELECT distinct o.Nom
        FROM Oeuvre o,NominationOeuvre p
        WHERE p.dateDeNomination >= '01-jan-2000' AND n.dateDeNomination <= '31-dec-2010'
        AND o.reference=p.referenceOeuvre);
;

-- Quels EP ont été réalisés par un groupe ayant au moins une nomination ?

SELECT distinct q.Nom
FROM Oeuvre q,Groupe g
WHERE q.type='EP'
AND q.nomGroupe=g.nomGrp
AND g.nomGrp in(SELECT distinct j.NomGrp
        FROM Groupe j,NominationGroupe n
        WHERE j.nomGrp=n.nomGroupe);
;

-- Quels sont les artistes ayant travaillé pour la réalisation du single [Nom d’un titre]?

SELECT distinct a.NomDeScene
FROM Artiste a, Oeuvre o,(SELECT Nom as Name
                    FROM Oeuvre
                    WHERE type='Single' AND Nom = '&nomSingle')Single
WHERE (o.type='Single' AND o.nom=Single.Name AND a.NomDeScene=o.nomArtiste)
OR a.NomDeScene IN (SELECT nomArtiste
            FROM CollaborationArtiste
            WHERE TitreMorceau=Single.Name)
OR a.NomDeScene IN (SELECT nomArtiste
            FROM MembreduGroupe
            WHERE nomGroupe IN(SELECT NomGroupe as Name
                           FROM Oeuvre
                            WHERE type='Single' AND Nom = Single.Name))
;

-- Quels musiciens ont participé à la création d'un album qui possède exactement 3 pistes ?

SELECT distinct a.NomDeScene
FROM Artiste a,Oeuvre o
WHERE (o.Type='Album' AND a.NomDeScene=o.nomArtiste AND (SELECT max(NumeroDePiste)
            FROM PisteOeuvre p
            WHERE p.ReferenceOeuvre = o.reference) =3)
OR a.NomDeScene in (SELECT  v.NomArtiste
            FROM MembreDuGroupe v,(SELECT g.NomGrp as nomgroupe
                      FROM Groupe g,Oeuvre n
                      WHERE (n.Type='Album' AND g.nomGrp=n.nomGroupe AND (SELECT max(NumeroDePiste)
                                                FROM PisteOeuvre p
                                                WHERE p.ReferenceOeuvre =                                                     n.reference) =3))groupes
            WHERE v.nomGroupe=groupes.nomgroupe);

