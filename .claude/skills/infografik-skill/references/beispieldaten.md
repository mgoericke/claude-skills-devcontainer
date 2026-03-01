# Beispiel-Datensätze für Demo-Infografiken

Verwende diese Daten wenn der Nutzer kein eigenes Dataset mitbringt, 
oder als Vorlage für ähnliche Themen.

---

## 📊 Marktanteile / Kreisdiagramm
```python
data_marktanteile = {
    'labels':  ['Produkt A', 'Produkt B', 'Produkt C', 'Sonstige'],
    'values':  [42, 28, 19, 11],
    'einheit': '%',
    'titel':   'Marktanteile 2025',
}
```

## 📈 Zeitreihe / Wachstum
```python
data_zeitreihe = {
    'jahre':   [2020, 2021, 2022, 2023, 2024, 2025],
    'werte':   [100, 118, 134, 152, 171, 195],
    'einheit': 'Mio. €',
    'titel':   'Umsatzentwicklung',
    'cagr':    '14,3 %',
}
```

## 🏢 Branchen-Vergleich / Balken
```python
data_branchen = {
    'branchen': ['Technologie', 'Finanzen', 'Gesundheit', 
                 'Industrie', 'Handel', 'Energie'],
    'werte':    [87, 74, 61, 55, 48, 39],
    'einheit':  '% Wachstum',
    'titel':    'Branchenwachstum YoY',
}
```

## 👥 Bevölkerung / Demografie
```python
data_demografie = {
    'altersgruppen': ['18–24', '25–34', '35–44', '45–54', '55–64', '65+'],
    'anteil':        [11, 18, 22, 20, 16, 13],
    'einheit':       '%',
    'titel':         'Altersstruktur Nutzerbasis',
}
```

## 🌍 Länder-Vergleich / Map-Daten
```python
data_laender = {
    'laender': ['Deutschland', 'Österreich', 'Schweiz', 
                'Frankreich', 'Niederlande'],
    'werte':   [100, 38, 45, 67, 29],
    'einheit': 'Mio. €',
    'titel':   'DACH+ Umsatz nach Land',
}
```

## 🤖 KI & Digitalisierung (Behörden-Kontext)
```python
data_digitalisierung = {
    'bereiche': ['Dokumentenverarbeitung', 'Bürger-Chat', 
                 'Antragsprüfung', 'Terminvergabe', 'Berichtswesen'],
    'automatisiert': [78, 65, 52, 88, 71],  # % automatisiert
    'einheit': '% digitalisiert',
    'titel':   'Digitalisierungsgrad Behördenprozesse 2025',
    'kpis': {
        'Anträge/Tag': '12.400',
        'Bearbeitungszeit': '↓ 67 %',
        'Fehlerquote': '0,3 %',
        'Nutzerzufriedenheit': '4,2 / 5',
    }
}
```

## 📋 Aufgaben / Status (Projekt-Dashboard)
```python
data_projekt = {
    'phasen': ['Konzept', 'Design', 'Entwicklung', 'Test', 'Rollout'],
    'status': ['✅ Fertig', '✅ Fertig', '🔄 In Arbeit', '⏳ Ausstehend', '⏳ Ausstehend'],
    'fortschritt': [100, 100, 60, 0, 0],
    'titel': 'Projektstatus Q1 2025',
}
```

---

## Daten einlesen vom Nutzer

Wenn der Nutzer eine CSV oder Tabelle mitschickt:
```python
import csv, io

# Aus Text parsen:
raw = """Name,Wert
Alpha,34
Beta,28
Gamma,19"""

reader = csv.DictReader(io.StringIO(raw))
data = [{'name': r['Name'], 'wert': float(r['Wert'])} for r in reader]
```
