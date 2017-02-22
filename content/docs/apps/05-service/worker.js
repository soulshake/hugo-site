var redis = require("redis");

var client = redis.createClient(process.env.REDIS_URL);

var dequeue = function() {
  client.blpop("queue", 0, function(err, data) {
    console.log(data)
    dequeue()
  })
};

client.on('connect', dequeue);

console.log("worker running");
