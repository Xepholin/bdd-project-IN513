CREATE TABLE Artiste (
    NomdeScene varchar(30) PRIMARY KEY NOT NULL,
    Nom varchar(30) NOT NULL,
    Naissance date NOT NULL,
    Nationalite varchar(30) NOT NULL,
    DebContrat date NOT NULL,
    FinContrat date,
    Instrument varchar(30),
    NomAgent varchar(30)
);

CREATE TABLE Groupe (
    NomGrp varchar(30) PRIMARY KEY NOT NULL,
    Nationalite varchar(30) NOT NULL,
    DateCreation date NOT NULL,
    DateSeparation date,
    DebContrat date NOT NULL,
    FinContrat date,
    NomAgent varchar(30)
);

CREATE TABLE MembreduGroupe (
    nomArtiste varchar(30) NOT NULL,
    nomGroupe varchar(30) NOT NULL,
    FOREIGN KEY (nomArtiste) references Artiste(NomdeScene),
    FOREIGN KEY (nomGroupe) references Groupe(NomGrp));
    CREATE TABLE Genre (
    Nom varchar(30) PRIMARY KEY,
    Dateapparition Date
);

CREATE TABLE Prix (
    Titre varchar(30) PRIMARY KEY NOT NULL
);

CREATE TABLE Oeuvre (
    Reference number(7) PRIMARY KEY NOT NULL,
    Nom varchar(30) NOT NULL,
    Producteur varchar(30),
    dateDeSortie date NOT NULL,
    Type varchar(30),
    Benefice number(15),
    nomGroupe varchar(30),
    nomArtiste varchar(30),
    FOREIGN KEY (nomGroupe) references Groupe(NomGrp),
    FOREIGN KEY (nomArtiste) references Artiste(NomdeScene)
);

CREATE TABLE NominationOeuvre (
    IdNomination number(5) PRIMARY KEY,
    dateDeNomination date,
    Statut varchar(7),
    ReferenceOeuvre number(7),
    titrePrix varchar(30) NOT NULL,
    FOREIGN KEY (referenceOeuvre) references Oeuvre(Reference),
    FOREIGN KEY (titrePrix) references Prix(Titre)
);

CREATE TABLE NominationArtiste (
    IdNomination number(5) PRIMARY KEY,
    dateDeNomination date,
    Statut varchar(7),
    nomArtiste varchar(30),
    titrePrix varchar(30) NOT NULL,
    FOREIGN KEY (nomArtiste) references Artiste(NomdeScene),
    FOREIGN KEY (titrePrix) references Prix(Titre)
);

CREATE TABLE NominationGroupe (
    IdNomination number(5) PRIMARY KEY,
    dateDeNomination date,
    Statut varchar(7),
    nomGroupe varchar(30),
    titrePrix varchar(30) NOT NULL,
    FOREIGN KEY (nomGroupe) references Groupe(NomGrp),
    FOREIGN KEY (titrePrix) references Prix(Titre)
);

CREATE TABLE ArtisteAppartientAuGenre (
    nomGenre varchar(30) NOT NULL,
    nomArtiste varchar(30),
    FOREIGN KEY (nomGenre) references Genre(Nom),
    FOREIGN KEY (nomArtiste) references Artiste(NomdeScene)
);

CREATE TABLE GroupeAppartientAuGenre (
    nomGenre varchar(30) NOT NULL,
    nomGroupe varchar(30),
    FOREIGN KEY (nomGenre) references Genre(Nom),
    FOREIGN KEY (nomGroupe) references Groupe(NomGrp)
);

CREATE TABLE OeuvreAppartientAuGenre (
    nomGenre varchar(30) NOT NULL,
    ReferenceOeuvre number(7),
    FOREIGN KEY (nomGenre) references Genre(Nom),
    FOREIGN KEY (ReferenceOeuvre) references Oeuvre(Reference)
);

CREATE TABLE Morceau (
    Titre varchar(30) PRIMARY KEY NOT NULL,
    Duree number(3) NOT NULL,
    CHECK (Duree <= 600)
);

CREATE TABLE PisteOeuvre (
    numeroDePiste number(3) NOT NULL,
    titreMorceau varchar(30) NOT NULL,
    ReferenceOeuvre number(7),
    FOREIGN KEY (titreMorceau) references Morceau(Titre),
    FOREIGN KEY (ReferenceOeuvre) references Oeuvre(Reference)
);

CREATE TABLE CollaborationArtiste (
    titreMorceau varchar(30) NOT NULL,
    nomArtiste varchar(30),
    FOREIGN KEY (titreMorceau) references Morceau(Titre),
    FOREIGN KEY (nomArtiste) references Artiste(NomdeScene)
);

CREATE TABLE CollaborationGroupe (
    titreMorceau varchar(30) NOT NULL,
    nomGroupe varchar(30),
    FOREIGN KEY (titreMorceau) references Morceau(Titre),
    FOREIGN KEY (nomGroupe) references Groupe(NomGrp)
);