-- Lösung Zusatzaufgaben Z1 und Z2 (setzt 04_to_3nf.sql voraus).
-- Z2 ändert Daten; erneutes Ausführen von 04_to_3nf.sql stellt den Ausgangszustand wieder her.

.headers on
.mode box

.print "Z1a: Exakte Suche (Vorname, Nachname, Geburtsdatum gleich) - findet nichts"
SELECT a.MitgliedNr AS Nr_A, b.MitgliedNr AS Nr_B, a.Vorname, a.Nachname, a.Geburtsdatum
FROM Mitglied_3NF a
JOIN Mitglied_3NF b
  ON a.MitgliedNr < b.MitgliedNr
 AND a.Vorname = b.Vorname
 AND a.Nachname = b.Nachname
 AND a.Geburtsdatum = b.Geburtsdatum;

.print "Z1b: Tolerante Suche (Name und Geburtsjahr gleich)"
SELECT a.MitgliedNr AS Nr_A, b.MitgliedNr AS Nr_B, a.Vorname, a.Nachname,
       a.Geburtsdatum AS Geb_A, b.Geburtsdatum AS Geb_B,
       a.Strasse || ' ' || a.Hausnummer AS Anschrift_A,
       b.Strasse || ' ' || b.Hausnummer AS Anschrift_B
FROM Mitglied_3NF a
JOIN Mitglied_3NF b
  ON a.MitgliedNr < b.MitgliedNr
 AND a.Vorname = b.Vorname
 AND a.Nachname = b.Nachname
 AND strftime('%Y', a.Geburtsdatum) = strftime('%Y', b.Geburtsdatum);

.print "Z2: Geburtsdatum von Mitglied 8 korrigieren"
UPDATE Mitglied_3NF SET Geburtsdatum = '1972-11-04' WHERE MitgliedNr = 8;
SELECT changes() AS Geaenderte_Zeilen;

.print "Z1a erneut: jetzt wird die Dublette exakt gefunden"
SELECT a.MitgliedNr AS Nr_A, b.MitgliedNr AS Nr_B, a.Vorname, a.Nachname, a.Geburtsdatum
FROM Mitglied_3NF a
JOIN Mitglied_3NF b
  ON a.MitgliedNr < b.MitgliedNr
 AND a.Vorname = b.Vorname
 AND a.Nachname = b.Nachname
 AND a.Geburtsdatum = b.Geburtsdatum;
