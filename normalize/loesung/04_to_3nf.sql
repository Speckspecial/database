-- Lösung Schritt 3: 2NF -> 3NF
-- Verstoß: In Mitglied_2NF gilt MitgliedNr -> PLZ -> Ort (transitive Abhängigkeit).
-- Zusätzlich: Stammtabelle Abteilung, damit Abteilungsnamen per Fremdschlüssel geprüft werden.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Mitglied_Ehrung_3NF;
DROP TABLE IF EXISTS Ehrungsstufe_3NF;
DROP TABLE IF EXISTS Abteilungsleitung_3NF;
DROP TABLE IF EXISTS Mitglied_Abteilung_3NF;
DROP TABLE IF EXISTS Abteilung_3NF;
DROP TABLE IF EXISTS Mitglied_3NF;
DROP TABLE IF EXISTS Ort_3NF;

CREATE TABLE Ort_3NF (
    PLZ TEXT PRIMARY KEY,
    Ort TEXT NOT NULL
);
INSERT INTO Ort_3NF SELECT DISTINCT PLZ, Ort FROM Mitglied_2NF;

CREATE TABLE Mitglied_3NF (
    MitgliedNr   INTEGER PRIMARY KEY,
    Vorname      TEXT NOT NULL,
    Nachname     TEXT NOT NULL,
    Geburtsdatum TEXT,
    Strasse      TEXT,
    Hausnummer   TEXT,
    PLZ          TEXT REFERENCES Ort_3NF (PLZ),
    Eintritt     TEXT NOT NULL,
    Austritt     TEXT
);
INSERT INTO Mitglied_3NF
SELECT MitgliedNr, Vorname, Nachname, Geburtsdatum, Strasse, Hausnummer, PLZ, Eintritt, Austritt
FROM Mitglied_2NF;

CREATE TABLE Abteilung_3NF (
    Abteilung TEXT PRIMARY KEY
);
INSERT INTO Abteilung_3NF
SELECT Abteilung FROM Mitglied_Abteilung_2NF
UNION
SELECT Abteilung FROM Abteilungsleitung_2NF;

CREATE TABLE Mitglied_Abteilung_3NF (
    MitgliedNr  INTEGER NOT NULL REFERENCES Mitglied_3NF (MitgliedNr),
    Abteilung   TEXT    NOT NULL REFERENCES Abteilung_3NF (Abteilung),
    AbtEintritt TEXT    NOT NULL,
    AbtAustritt TEXT,
    PRIMARY KEY (MitgliedNr, Abteilung, AbtEintritt)
);
INSERT INTO Mitglied_Abteilung_3NF SELECT * FROM Mitglied_Abteilung_2NF;

CREATE TABLE Abteilungsleitung_3NF (
    Abteilung    TEXT    NOT NULL REFERENCES Abteilung_3NF (Abteilung),
    LeitungStart TEXT    NOT NULL,
    LeitungEnde  TEXT,
    MitgliedNr   INTEGER NOT NULL REFERENCES Mitglied_3NF (MitgliedNr),
    PRIMARY KEY (Abteilung, LeitungStart)
);
INSERT INTO Abteilungsleitung_3NF SELECT * FROM Abteilungsleitung_2NF;

CREATE TABLE Ehrungsstufe_3NF (
    Ehrung       TEXT    PRIMARY KEY,
    Mindestjahre INTEGER NOT NULL
);
INSERT INTO Ehrungsstufe_3NF SELECT * FROM Ehrungsstufe_2NF;

CREATE TABLE Mitglied_Ehrung_3NF (
    MitgliedNr   INTEGER NOT NULL REFERENCES Mitglied_3NF (MitgliedNr),
    Ehrung       TEXT    NOT NULL REFERENCES Ehrungsstufe_3NF (Ehrung),
    Ehrungsdatum TEXT    NOT NULL,
    PRIMARY KEY (MitgliedNr, Ehrung)
);
INSERT INTO Mitglied_Ehrung_3NF SELECT * FROM Mitglied_Ehrung_2NF;

.headers on
.mode box
SELECT * FROM Ort_3NF;
SELECT * FROM Mitglied_3NF;
SELECT * FROM Abteilung_3NF;

-- Probe: die Mitgliederliste lässt sich per JOIN wieder vollständig herstellen
SELECT m.MitgliedNr, m.Vorname, m.Nachname, m.Strasse || ' ' || m.Hausnummer AS Strasse,
       o.PLZ, o.Ort, ma.Abteilung, ma.AbtEintritt, ma.AbtAustritt
FROM Mitglied_3NF m
JOIN Ort_3NF o                 ON o.PLZ = m.PLZ
LEFT JOIN Mitglied_Abteilung_3NF ma ON ma.MitgliedNr = m.MitgliedNr
ORDER BY m.MitgliedNr, ma.AbtEintritt;
