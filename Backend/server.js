const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

app.use(bodyParser.json());

app.get('/data', (req, res) => {
  // Hier kannst du die Daten logisch generieren oder aus einer Datenbank abrufen
  const data = { message: 'Hello from Node.js server!' };
  res.json(data);
});

app.post('/sendData', (req, res) => {
    const { name, email } = req.body;
    console.log('Empfangene Daten:', name, email);
    // Hier kannst du die empfangenen Daten verarbeiten, z.B. in einer Datenbank speichern
    res.send('Daten erfolgreich empfangen');
  });

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});