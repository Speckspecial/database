# Aufgabe: Normalisierung der Mitgliederdatei

Ein Sportverein verwaltet seine Mitglieder bisher in einer einzigen Tabelle `Mitglieder_0NF`.
Erzeuge sie mit [01_create_0nf.sql](01_create_0nf.sql) (siehe [README](../README.md)).

## Fachliche Regeln

- Ein Mitglied hat eine **MitgliedNr**, ein Eintritts- und ein Austrittsdatum. Bei aktiven Mitgliedern ist das Austrittsdatum leer.
- Ein Mitglied kann in mehreren **Abteilungen** sein (Kopfstandball, Tanzball, Quidditch, Calvinball), jeweils mit eigenem Ein- und Austrittsdatum.
- Eine Abteilung hat zu einem Zeitpunkt höchstens einen **Abteilungsleiter**. Er ist selbst Mitglied. Die Leitung hat ein Start- und ein Enddatum. Weil die Datei nicht vollständig ist, kann es Zeiträume ohne Abteilungsleiter geben.
- Für lange Mitgliedschaft gibt es **Ehrungen**: Bronze nach 10, Silber nach 25 und Gold nach 40 Jahren. Es zählt nur die aktuelle Mitgliedschaft ab dem Eintrittsdatum. Geehrt wird auf der nächsten **Vereinsversammlung**. Das Ehrungsdatum ist der Tag dieser Versammlung und lässt sich daher nicht aus dem Eintrittsdatum berechnen.
- Tritt jemand nach einem Austritt wieder ein, bekommt er eine **neue MitgliedNr**.
- Namen und Geburtsdaten stammen aus handschriftlichen Anträgen. Sie müssen erfahrungsgemäß manchmal noch Jahre später korrigiert werden.
- Namen können sich außerdem durch **Heirat** ändern.

In der Tabelle stehen manche Angaben als **Listen**, getrennt mit `;`. Einträge an gleicher
Position gehören zusammen. Ein leerer Listeneintrag beim Enddatum bedeutet „noch aktiv“.

## ERM der Ausgangstabelle

```mermaid
erDiagram
    Mitglieder_0NF {
        INTEGER MitgliedNr PK
        TEXT Name "Vor- und Nachname"
        TEXT Geburtsdatum
        TEXT Anschrift "Strasse Nr, PLZ Ort"
        TEXT Eintritt
        TEXT Austritt "leer = aktiv"
        TEXT Abteilungen "Liste"
        TEXT AbtEintritt "Liste"
        TEXT AbtAustritt "Liste"
        TEXT Ehrungen "Liste"
        TEXT EhrungJahre "Liste"
        TEXT Ehrungsdatum "Liste"
        TEXT LeitetAbteilung "Liste"
        TEXT LeitungStart "Liste"
        TEXT LeitungEnde "Liste"
    }
```

## Aufgaben

Schreibe für jeden Schritt ein SQL-Skript, das die neuen Tabellen anlegt und **per SQL aus den
Tabellen des vorherigen Schritts befüllt**. Daten nicht von Hand abtippen!
Hänge an die Tabellennamen die Stufe an, z.B. `Mitglied_1NF`. So bleiben alle Stufen
nebeneinander in der Datenbank erhalten.

1. **Analyse:** Gegen welche Regeln der 1NF verstößt `Mitglieder_0NF`? Nenne alle betroffenen Spalten.
2. **1NF** (`02_to_1nf.sql`): Überführe die Tabelle in die 1NF.
   - Jedes Feld enthält genau einen atomaren Wert (Vorname, Nachname, Straße, Hausnummer, PLZ, Ort, ...).
   - Lagere die Wiederholungsgruppen in eigene Tabellen aus.
   - Lege für jede Tabelle einen Primärschlüssel fest und begründe ihn.
3. **2NF** (`03_to_2nf.sql`): Suche Attribute, die nur von einem **Teil** eines zusammengesetzten Schlüssels abhängen, und lagere sie aus. Lege Fremdschlüssel an.
4. **3NF** (`04_to_3nf.sql`): Suche **transitive** Abhängigkeiten (Nicht-Schlüssel → Nicht-Schlüssel) und lagere sie aus.
5. **ERM:** Zeichne das ERM deines Ergebnisses der 3NF.

### Zusatzaufgaben

- **Z1:** Mitglied 8 ist offenbar Moritz Bleibtreu, der wieder eingetreten ist. Schreibe eine Abfrage, die mögliche **Dubletten** findet.
  - Findet eine exakte Suche (Name und Geburtsdatum gleich) ihn?
  - Wie muss die Suche aussehen, damit sie den Fall findet?
- **Z2:** Auf dem Antrag von Mitglied 8 wurde das Geburtsdatum falsch gelesen. Richtig ist `1972-11-04`.
  - Korrigiere es per `UPDATE`.
  - Wie viele Zeilen ändern sich?
  - Warum ist es wichtig, dass die anderen Tabellen auf die `MitgliedNr` verweisen und nicht auf Name oder Geburtsdatum?

## Tipps

<details>
<summary>Nützliche SQLite-Funktionen</summary>

| Funktion | Beispiel | Ergebnis |
|---|---|---|
| `instr(text, such)` | `instr('Max Müller', ' ')` | `4` |
| `substr(text, start, laenge)` | `substr('Max Müller', 1, 3)` | `'Max'` |
| `trim(text)` | `trim('  a ')` | `'a'` |
| `rtrim(text, zeichen)` | `rtrim('Am Markt 1', '0123456789')` | `'Am Markt '` |
| `NULLIF(a, b)` | `NULLIF('', '')` | `NULL` |
| `strftime('%Y', datum)` | `strftime('%Y', '1972-11-04')` | `'1972'` |

</details>

<details>
<summary>Felder in Teilfelder zerlegen (substr, trim, rtrim, ltrim, length)</summary>

**`substr(text, start [, laenge])`** schneidet einen Teil aus dem Text aus.
- Die Zählung beginnt bei **1**, nicht bei 0.
- Ohne `laenge` geht der Ausschnitt bis zum Ende des Textes.
- Ein **negativer** `start` zählt vom Ende her.

| Beispiel | Ergebnis |
|---|---|
| `substr('12345 Musterstadt', 1, 5)` | `'12345'` |
| `substr('12345 Musterstadt', 7)` | `'Musterstadt'` |
| `substr('Musterweg 12', -2)` | `'12'` |

**`trim`, `ltrim`, `rtrim`** entfernen Zeichen: `trim` an beiden Enden, `ltrim` nur links, `rtrim` nur rechts.
- Ohne zweites Argument werden Leerzeichen entfernt.
- Mit zweitem Argument werden **alle Zeichen aus dieser Menge** entfernt, in beliebiger Reihenfolge, bis ein Zeichen kommt, das nicht in der Menge steht. Das zweite Argument ist also keine feste Zeichenfolge.

| Beispiel | Ergebnis |
|---|---|
| `trim('  Musterweg ')` | `'Musterweg'` |
| `ltrim('0042', '0')` | `'42'` |
| `trim('; a ;', '; ')` | `'a'` |
| `rtrim('Musterweg 12', '0123456789')` | `'Musterweg '` |
| `rtrim('Weg 7a', '0123456789')` | `'Weg 7a'` (unverändert, weil `a` keine Ziffer ist) |

**`length(text)`** liefert die Anzahl der **Zeichen** (nicht Bytes): `length('Müller')` ergibt `6`.

**Typische Kombinationen** mit `instr`:

| Ziel | Ausdruck |
|---|---|
| Teil **vor** dem Trennzeichen | `substr(t, 1, instr(t, ',') - 1)` |
| Teil **nach** dem Trennzeichen | `trim(substr(t, instr(t, ',') + 1))` |
| Text ohne Ziffern am Ende | `trim(rtrim(t, '0123456789'))` |
| Nur die Ziffern am Ende | `substr(t, length(rtrim(t, '0123456789')) + 1)` |

Das letzte Beispiel funktioniert so: `rtrim` entfernt die Ziffern am Ende, und `length` misst, wie lang der Rest ist. Ab der Stelle danach beginnt die Nummer.

**Fallstricke:**
- Fehlt das Trennzeichen, liefert `instr` den Wert `0`. Dann ergibt `substr(t, 1, -1)` einen leeren Text.
- Bei Doppelnamen wie „Anna Lena Schmidt“ trennt das **erste** Leerzeichen den Vornamen falsch ab.
- Hausnummern wie `7a` lassen sich mit `rtrim(…, '0123456789')` nicht abtrennen.

</details>

<details>
<summary>Listen zerlegen</summary>

SQLite hat keine Split-Funktion. Eine Liste lässt sich mit einer **rekursiven CTE** zerlegen:
Schneide in jedem Rekursionsschritt das Element bis zum ersten `;` ab und zähle eine
Position mit. Über `MitgliedNr` und Position lassen sich danach zusammengehörige Einträge
verschiedener Listen wieder verbinden.

```sql
WITH RECURSIVE Zerlegt(Pos, Wert, Rest) AS (
    SELECT 0, NULL, 'a; b; c' || ';'
    UNION ALL
    SELECT Pos + 1,
           trim(substr(Rest, 1, instr(Rest, ';') - 1)),
           substr(Rest, instr(Rest, ';') + 1)
    FROM Zerlegt
    WHERE Rest <> ''
)
SELECT Pos, Wert FROM Zerlegt WHERE Pos > 0;
```

</details>
