-- Lösung Schritt 2: 1NF -> 2NF
-- Verstoß: In Mitglied_Ehrung_1NF hängt EhrungJahre nur von Ehrung ab (Teil des Schlüssels).
-- Alle anderen Tabellen erfüllen die 2NF bereits und werden unverändert übernommen.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Mitglied_Ehrung_2NF;
DROP TABLE IF EXISTS Ehrungsstufe_2NF;
DROP TABLE IF EXISTS Abteilungsleitung_2NF;
DROP TABLE IF EXISTS Mitglied_Abteilung_2NF;
DROP TABLE IF EXISTS Mitglied_2NF;

CREATE TABLE Mitglied_2NF (
    MitgliedNr   INTEGER PRIMARY KEY,
    Vorname      TEXT NOT NULL,
    Nachname     TEXT NOT NULL,
    Geburtsdatum TEXT,
    Strasse      TEXT,
    Hausnummer   TEXT,
    PLZ          TEXT,
    Ort          TEXT,
    Eintritt     TEXT NOT NULL,
    Austritt     TEXT
);
INSERT INTO Mitglied_2NF SELECT * FROM Mitglied_1NF;

CREATE TABLE Mitglied_Abteilung_2NF (
    MitgliedNr  INTEGER NOT NULL REFERENCES Mitglied_2NF (MitgliedNr),
    Abteilung   TEXT    NOT NULL,
    AbtEintritt TEXT    NOT NULL,
    AbtAustritt TEXT,
    PRIMARY KEY (MitgliedNr, Abteilung, AbtEintritt)
);
INSERT INTO Mitglied_Abteilung_2NF SELECT * FROM Mitglied_Abteilung_1NF;

CREATE TABLE Abteilungsleitung_2NF (
    Abteilung    TEXT    NOT NULL,
    LeitungStart TEXT    NOT NULL,
    LeitungEnde  TEXT,
    MitgliedNr   INTEGER NOT NULL REFERENCES Mitglied_2NF (MitgliedNr),
    PRIMARY KEY (Abteilung, LeitungStart)
);
INSERT INTO Abteilungsleitung_2NF SELECT * FROM Abteilungsleitung_1NF;

-- Neu: Ehrungsstufe mit Mindestjahren
CREATE TABLE Ehrungsstufe_2NF (
    Ehrung       TEXT    PRIMARY KEY,
    Mindestjahre INTEGER NOT NULL
);
INSERT INTO Ehrungsstufe_2NF
SELECT DISTINCT Ehrung, EhrungJahre FROM Mitglied_Ehrung_1NF;

CREATE TABLE Mitglied_Ehrung_2NF (
    MitgliedNr   INTEGER NOT NULL REFERENCES Mitglied_2NF (MitgliedNr),
    Ehrung       TEXT    NOT NULL REFERENCES Ehrungsstufe_2NF (Ehrung),
    Ehrungsdatum TEXT    NOT NULL,
    PRIMARY KEY (MitgliedNr, Ehrung)
);
INSERT INTO Mitglied_Ehrung_2NF
SELECT MitgliedNr, Ehrung, Ehrungsdatum FROM Mitglied_Ehrung_1NF;

.headers on
.mode box
SELECT * FROM Ehrungsstufe_2NF ORDER BY Mindestjahre;
SELECT * FROM Mitglied_Ehrung_2NF ORDER BY MitgliedNr, Ehrungsdatum;
