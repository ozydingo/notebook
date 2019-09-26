const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res) => res.send('Hello, world!'));
app.post('/', (req, res) => {
  res.send(req.body);
})
app.listen(port, () => console.log(`Example app listening on port ${port}!`));
