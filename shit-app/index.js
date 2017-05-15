const express = require('express');
const redis = require('redis');
const os = require('os');
const app = express();

var client = redis.createClient({
    host: 'redis'
});

app.get('/', function(req, res, next) {
    var times = client.incr('times', function(err, repl) {
        res.send('Hello from ' + os.hostname() + '! loaded ' + repl + ' times\n');
    });
});

const port = process.env.PORT || 3000;

app.listen(port, function() {
    console.log("Listening on http://" + os.hostname() + ":" + port);
});
