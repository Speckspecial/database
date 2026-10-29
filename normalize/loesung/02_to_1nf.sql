-- Lösung Schritt 1: 0NF -> 1NF
-- Atomare Werte (Name, Anschrift zerlegt), Wiederholungsgruppen in eigene Tabellen.

DROP TABLE IF EXISTS Mitglied_Ehrung_1NF;
DROP TABLE IF EXISTS Abteilungsleitung_1NF;
DROP TABLE IF EXISTS Mitglied_Abteilung_1NF;
DROP TABLE IF EXISTS Mitglied_1NF;
DROP TABLE IF EXISTS temp.Listenwerte;

-- Hilfstabelle: jede Liste zerlegt in (MitgliedNr, Spalte, Pos, Wert)
CREATE TEMP TABLE Listenwerte AS
WITH RECURSIVE
Listen(MitgliedNr, Spalte, Liste) AS (
    SELECT MitgliedNr, 'Abteilungen',     Abteilungen     FROM Mitglieder_0NF UNION ALL
    SELECT MitgliedNr, 'AbtEintritt',     AbtEintritt     FROM Mitglieder_0NF UNION ALL
    SELECT MitgliedNr, 'AbtAustritt',     AbtAustritt     FROM Mitglieder_0NF UNION ALL
    SELECT MitgliedNr, 'Ehrungen',        Ehrungen        FROM Mitglieder_0NF UNION ALL
    SELECT MitgliedNr, 'EhrungJahre',     EhrungJahre     FROM Mitglieder_0NF UNION ALL
    SELECT MitgliedNr, 'Ehrungsdatum',    Ehrungsdatum    FROM Mitglieder_0NF UNION ALL
    SELECT MitgliedNr, 'LeitetAbteilung', LeitetAbteilung FROM Mitglieder_0NF UNION ALL
    SELECT MitgliedNr, 'LeitungStart',    LeitungStart    FROM Mitglieder_0NF UNION ALL
    SELECT MitgliedNr, 'LeitungEnde',     LeitungEnde     FROM Mitglieder_0NF
),
Zerlegt(MitgliedNr, Spalte, Pos, Wert, Rest) AS (
    SELECT MitgliedNr, Spalte, 0, NULL, Liste || ';'
    FROM Listen
    WHERE Liste IS NOT NULL
    UNION ALL
    SELECT MitgliedNr, Spalte, Pos + 1,
           NULLIF(trim(substr(Rest, 1, instr(Rest, ';') - 1)), ''),
           substr(Rest, instr(Rest, ';') + 1)
    FROM Zerlegt
    WHERE Rest <> ''
)
SELECT MitgliedNr, Spalte, Pos, Wert FROM Zerlegt WHERE Pos > 0;

-- Stammdaten des Mitglieds
CREATE TABLE Mitglied_1NF (
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

-- rtrim(x, '0123456789') schneidet die Hausnummer am Ende ab
INSERT INTO Mitglied_1NF
SELECT MitgliedNr,
       substr(Name, 1, instr(Name, ' ') - 1),
       substr(Name, instr(Name, ' ') + 1),
       Geburtsdatum,
       trim(rtrim(StrasseNr, '0123456789')),
       substr(StrasseNr, length(rtrim(StrasseNr, '0123456789')) + 1),
       substr(PlzOrt, 1, 5),
       trim(substr(PlzOrt, 6)),
       Eintritt,
       Austritt
FROM (
    SELECT *,
           trim(substr(Anschrift, 1, instr(Anschrift, ',') - 1)) AS StrasseNr,
           trim(substr(Anschrift, instr(Anschrift, ',') + 1))    AS PlzOrt
    FROM Mitglieder_0NF
);

-- Wiederholungsgruppe Abteilungen (Wiedereintritt in dieselbe Abteilung möglich)
CREATE TABLE Mitglied_Abteilung_1NF (
    MitgliedNr  INTEGER NOT NULL,
    Abteilung   TEXT    NOT NULL,
    AbtEintritt TEXT    NOT NULL,
    AbtAustritt TEXT,
    PRIMARY KEY (MitgliedNr, Abteilung, AbtEintritt)
);

INSERT INTO Mitglied_Abteilung_1NF
SELECT a.MitgliedNr, a.Wert, e.Wert, x.Wert
FROM Listenwerte a
LEFT JOIN Listenwerte e ON e.MitgliedNr = a.MitgliedNr AND e.Pos = a.Pos AND e.Spalte = 'AbtEintritt'
LEFT JOIN Listenwerte x ON x.MitgliedNr = a.MitgliedNr AND x.Pos = a.Pos AND x.Spalte = 'AbtAustritt'
WHERE a.Spalte = 'Abteilungen';

-- Wiederholungsgruppe Abteilungsleitung (eine Abteilung hat zu einem Zeitpunkt genau einen Leiter)
CREATE TABLE Abteilungsleitung_1NF (
    Abteilung    TEXT    NOT NULL,
    LeitungStart TEXT    NOT NULL,
    LeitungEnde  TEXT,
    MitgliedNr   INTEGER NOT NULL,
    PRIMARY KEY (Abteilung, LeitungStart)
);

INSERT INTO Abteilungsleitung_1NF
SELECT a.Wert, s.Wert, x.Wert, a.MitgliedNr
FROM Listenwerte a
LEFT JOIN Listenwerte s ON s.MitgliedNr = a.MitgliedNr AND s.Pos = a.Pos AND s.Spalte = 'LeitungStart'
LEFT JOIN Listenwerte x ON x.MitgliedNr = a.MitgliedNr AND x.Pos = a.Pos AND x.Spalte = 'LeitungEnde'
WHERE a.Spalte = 'LeitetAbteilung';

-- Wiederholungsgruppe Ehrungen (jede Stufe pro Mitgliedschaft höchstens einmal)
CREATE TABLE Mitglied_Ehrung_1NF (
    MitgliedNr   INTEGER NOT NULL,
    Ehrung       TEXT    NOT NULL,
    EhrungJahre  INTEGER NOT NULL,
    Ehrungsdatum TEXT    NOT NULL,
    PRIMARY KEY (MitgliedNr, Ehrung)
);

INSERT INTO Mitglied_Ehrung_1NF
SELECT a.MitgliedNr, a.Wert, CAST(j.Wert AS INTEGER), d.Wert
FROM Listenwerte a
LEFT JOIN Listenwerte j ON j.MitgliedNr = a.MitgliedNr AND j.Pos = a.Pos AND j.Spalte = 'EhrungJahre'
LEFT JOIN Listenwerte d ON d.MitgliedNr = a.MitgliedNr AND d.Pos = a.Pos AND d.Spalte = 'Ehrungsdatum'
WHERE a.Spalte = 'Ehrungen';

DROP TABLE temp.Listenwerte;

.headers on
.mode box
SELECT * FROM Mitglied_1NF;
SELECT * FROM Mitglied_Abteilung_1NF ORDER BY MitgliedNr, AbtEintritt;
SELECT * FROM Abteilungsleitung_1NF ORDER BY Abteilung, LeitungStart;
SELECT * FROM Mitglied_Ehrung_1NF ORDER BY MitgliedNr, Ehrungsdatum;
