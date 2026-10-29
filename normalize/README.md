# Normalisierung – Mitgliederdatei eines Sportvereins

Übung zur Normalisierung einer Tabelle von der 0NF bis zur 3NF mit SQLite.

- [aufgabe/AUFGABE.md](aufgabe/AUFGABE.md) – Aufgabenstellung
- [aufgabe/01_create_0nf.sql](aufgabe/01_create_0nf.sql) – erzeugt die Ausgangstabelle
- [loesung/](loesung/) – Musterlösung (erst nach Bearbeitung ansehen)

## Inhalt

- [Installation](#installation)
- [Tabellen anlegen](#tabellen-anlegen)
- [Interaktiv arbeiten](#interaktiv-arbeiten)
- [SQL lernen und nachschlagen](#sql-lernen-und-nachschlagen)

## Installation

SQLite ist ein Datenbanksystem ohne Server: Die ganze Datenbank ist eine einzige Datei.
Benötigt wird nur das Kommandozeilenprogramm `sqlite3.exe`.

1. In PowerShell installieren (kein Administrator nötig):

   ```powershell
   winget install --id SQLite.SQLite -e
   ```

2. PowerShell bzw. VS Code **neu starten**, damit der geänderte `PATH` gilt.
3. Prüfen:

   ```powershell
   sqlite3 --version
   ```

Optional: VS Code-Erweiterung **SQLite Viewer**, um die Datenbank-Datei grafisch anzusehen.

## Tabellen anlegen

Die Dateien sind SQL-Skripte. Sie werden nacheinander auf **dieselbe** Datenbank-Datei
angewendet. Existiert die Datei noch nicht, legt `sqlite3` sie an.

```powershell
cd database\normalize
sqlite3 verein.db ".read aufgabe/01_create_0nf.sql"
```

Musterlösung, Schritt für Schritt:

```powershell
sqlite3 verein.db ".read loesung/02_to_1nf.sql"
sqlite3 verein.db ".read loesung/03_to_2nf.sql"
sqlite3 verein.db ".read loesung/04_to_3nf.sql"
sqlite3 verein.db ".read loesung/05_zusatz.sql"
```

> In PowerShell funktioniert `sqlite3 verein.db < datei.sql` nicht. Deshalb `".read datei.sql"` verwenden.

Jedes Skript löscht seine Tabellen zuerst (`DROP TABLE IF EXISTS`) und kann daher beliebig oft
ausgeführt werden. Für einen kompletten Neustart einfach `verein.db` löschen.

## Interaktiv arbeiten

```powershell
sqlite3 verein.db
```

Nützliche Befehle in der SQLite-Shell:

| Befehl | Wirkung |
|---|---|
| `.tables` | alle Tabellen anzeigen |
| `.schema Mitglieder_0NF` | `CREATE TABLE` einer Tabelle anzeigen |
| `.headers on` und `.mode box` | Abfrageergebnisse als Tabelle anzeigen |
| `.read datei.sql` | Skript ausführen |
| `.quit` | beenden |

## SQL lernen und nachschlagen

- [SQLBolt](https://sqlbolt.com/) – interaktive Lektionen und Übungen zu den SQL-Grundlagen.
- [SQLZoo](https://sqlzoo.net/wiki/SQL_Tutorial) – Schritt-für-Schritt-Tutorials mit Übungen zu `SELECT`, Joins und Aggregatfunktionen.
- [W3Schools SQL Tutorial](https://www.w3schools.com/sql/) – Referenz zum Nachschlagen mit Beispielen und Übungen.
