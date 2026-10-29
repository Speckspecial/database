-- Ausgangslage: Mitgliederdatei eines Sportvereins in 0NF (nicht normalisiert).
-- Listen sind mit ';' getrennt, Einträge gehören über ihre Position zusammen.
-- Leeres Feld bzw. leerer Listeneintrag beim Enddatum = noch aktiv.
-- Ehrungsdatum = Tag der Vereinsversammlung nach Erreichen der Mindestjahre.

DROP TABLE IF EXISTS Mitglieder_0NF;

CREATE TABLE Mitglieder_0NF (
    MitgliedNr      INTEGER PRIMARY KEY,
    Name            TEXT,
    Geburtsdatum    TEXT,
    Anschrift       TEXT,
    Eintritt        TEXT,
    Austritt        TEXT,
    Abteilungen     TEXT,
    AbtEintritt     TEXT,
    AbtAustritt     TEXT,
    Ehrungen        TEXT,
    EhrungJahre     TEXT,
    Ehrungsdatum    TEXT,
    LeitetAbteilung TEXT,
    LeitungStart    TEXT,
    LeitungEnde     TEXT
);

INSERT INTO Mitglieder_0NF VALUES
(1, 'Joachim Llambi',     '1965-07-12', 'Gandalfstr. 5, 01111 Hobbingen',   '1980-04-01', NULL,
    'Kopfstandball; Tanzball',      '1980-04-01; 1995-06-15',             '2000-12-31; ',
    'Bronze; Silber; Gold', '10; 25; 40', '1991-03-15; 2006-03-17; 2021-03-19',
    'Tanzball',        '2005-01-01',             NULL),
(2, 'Lena Meyer-Landrut', '1992-03-28', 'Cantinagasse 12, 47110 Mos Eisley',   '2005-09-01', NULL,
    'Calvinball; Quidditch',        '2005-09-01; 2012-01-10',             '; ',
    'Bronze',               '10',         '2016-03-18',
    'Quidditch',       '2018-01-01',             NULL),
(3, 'Moritz Bleibtreu',   '1972-11-04', 'Beutelsendweg 3, 01111 Hobbingen',  '1990-01-15', '2018-06-30',
    'Kopfstandball',                '1990-01-15',                         '2018-06-30',
    'Bronze; Silber',       '10; 25',     '2000-03-24; 2015-03-20',
    'Kopfstandball',   '2000-01-01',             '2018-06-30'),
(4, 'North West',         '2012-06-19', 'Warpkernweg 7a, 17010 Utopia Planitia',    '2021-02-01', NULL,
    'Calvinball; Quidditch; Tanzball', '2021-02-01; 2021-02-01; 2023-04-01', '; 2022-12-31; ',
    NULL,                   NULL,         NULL,
    NULL,              NULL,                     NULL),
(5, 'Antonio Banderas',   '1960-01-23', 'Am Sarlacc 1, 47110 Mos Eisley',     '1975-03-01', '2024-12-31',
    'Kopfstandball; Calvinball',    '1975-03-01; 1990-09-01',             '2024-12-31; 2010-06-30',
    'Bronze; Silber; Gold', '10; 25; 40', '1985-03-22; 2000-03-24; 2015-03-20',
    'Calvinball; Kopfstandball', '1990-09-01; 2018-07-01', '2010-06-30; 2024-12-31'),
(6, 'Motsi Mabuse',       '1985-09-30', 'Holodeckallee 9, 17010 Utopia Planitia',   '2008-05-01', NULL,
    'Calvinball',                   '2008-05-01',                         NULL,
    'Bronze',               '10',         '2019-03-22',
    'Calvinball',      '2010-07-01',             NULL),
(7, 'Finn Wolfhard',      '2004-02-14', 'Lichtschwertstr. 22, 47110 Mos Eisley', '2019-08-15', NULL,
    'Kopfstandball; Quidditch',     '2019-08-15; 2020-03-01',             '; ',
    NULL,                   NULL,         NULL,
    'Kopfstandball',   '2025-01-01',             NULL),
-- Wiedereintritt von Moritz Bleibtreu; Geburtsdatum vom Antrag falsch abgelesen (4 -> 7)
(8, 'Moritz Bleibtreu',   '1972-11-07', 'Beutelsendweg 17, 01111 Hobbingen', '2022-03-01', NULL,
    'Kopfstandball; Tanzball',      '2022-03-01; 2023-09-01',             '; ',
    NULL,                   NULL,         NULL,
    NULL,              NULL,                     NULL);

.headers on
.mode box
SELECT * FROM Mitglieder_0NF;
