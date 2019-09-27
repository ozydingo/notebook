const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 80;

const redis = require('redis');
const redisConfig = {
  url: process.env['AM_I_DOCKER'] === 'true' ? "redis://redis" : null
}

let client
try {
  client = redis.createClient(redisConfig);
  client.on("error", (err) => {
    console.error("Redis error:", err);
  });
} catch(err) {
  console.error("Could not connect to redis");
}

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

app.post('/work', (req, res) => {
  if (!client || !client.connected) {
    res.status(503).send({errors: ["Not connected to redis"]})
  }

  const n = Number(req.body.n) || 10;
  const queue = req.body.queue || 'default';
  const queueKey = `resque:queue:${queue}`
  const data = {
    "class": "MyWorker",
    "args": [n],
  }
  client.rpush(queueKey, JSON.stringify(data));
  res.send(data);
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
