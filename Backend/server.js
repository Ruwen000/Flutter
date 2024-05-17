const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const deals = require("./Datenbank/deals.json");
const konten = require("./Datenbank/konten.json");
const app = express();
const port = 3000;

const newData = {
  id: 2,
  dealMit: 'Ruwen',
};

app.use(bodyParser.json());

app.get('/deals', (req, res) => {
  // Hier kannst du die Daten logisch generieren oder aus einer Datenbank abrufen
  res.json(deals);
});

app.get('/konten', (req, res) => {
  // Hier kannst du die Daten logisch generieren oder aus einer Datenbank abrufen
  res.json(konten);
});

console.log(deals);

app.post('/sendData', (req, res) => {
    const { name, email } = req.body;
    console.log('Empfangene Daten:', name, email);
    // Hier kannst du die empfangenen Daten verarbeiten, z.B. in einer Datenbank speichern
    res.send('Daten erfolgreich empfangen');
  });

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});

function updateJsonFile(filePath, newData) {
  // Schritt 1: Datei lesen
  fs.readFile(filePath, 'utf8', (err, data) => {
      if (err) {
          console.error('Fehler beim Lesen der Datei:', err);
          return;
      }

      // Vorhandene Daten parsen
      let jsonData;
      try {
          jsonData = JSON.parse(data);
      } catch (parseErr) {
          console.error('Fehler beim Parsen der JSON-Daten:', parseErr);
          return;
      }

      // Schritt 2: Neue Daten hinzufügen
      if (Array.isArray(jsonData)) {
          jsonData.push(newData); // Wenn jsonData ein Array ist, füge das neue Element hinzu
      } else if (typeof jsonData === 'object') {
          jsonData[newData.id] = newData; // Wenn jsonData ein Objekt ist, füge eine neue Eigenschaft hinzu
      } else {
          console.error('Unerwartetes JSON-Datenformat');
          return;
      }

      // Schritt 3: Datei speichern
      fs.writeFile(filePath, JSON.stringify(jsonData, null, 2), 'utf8', (writeErr) => {
          if (writeErr) {
              console.error('Fehler beim Schreiben der Datei:', writeErr);
              return;
          }

          console.log('Datei erfolgreich aktualisiert');
      });
  });
}

function deleteFromJsonFile(filePath, idToDelete) {
  // Schritt 1: Datei lesen
  fs.readFile(filePath, 'utf8', (err, data) => {
      if (err) {
          console.error('Fehler beim Lesen der Datei:', err);
          return;
      }

      // Vorhandene Daten parsen
      let jsonData;
      try {
          jsonData = JSON.parse(data);
      } catch (parseErr) {
          console.error('Fehler beim Parsen der JSON-Daten:', parseErr);
          return;
      }

      // Schritt 2: Daten löschen
      if (Array.isArray(jsonData)) {
          jsonData = jsonData.filter(item => item.id !== idToDelete);
      } else {
          console.error('Die JSON-Daten sind kein Array');
          return;
      }

      // Schritt 3: Datei speichern
      fs.writeFile(filePath, JSON.stringify(jsonData, null, 2), 'utf8', (writeErr) => {
          if (writeErr) {
              console.error('Fehler beim Schreiben der Datei:', writeErr);
              return;
          }

          console.log('Eintrag erfolgreich gelöscht und Datei aktualisiert');
      });
  });
}