const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

function middle(func) {
  return (req, res, next) => {
    logRequest(req, res);
    next();
  }
}

function logRequest(req, res) {
  console.log(`Started ${req.method} for ${req.url}`);
  console.log('Request headers:', req.headers);
  console.log('Requuest body:', req.body);
  console.log('Request query:', req.query);
}

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(middle(logRequest))
app.use(express.static(__dirname));

app.post('/', (req, res) => {
  res.send(req.body);
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
