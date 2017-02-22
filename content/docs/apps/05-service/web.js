var http = require("http");
var redis = require("redis");

var client = redis.createClient(process.env.REDIS_URL);

var server = http.createServer(function(request, response) {
  console.log(request.method, request.url)

  client.rpush("queue", JSON.stringify(request.headers));

  response.writeHead(200, {
    "Content-Type": "text/plain"
  });
  response.end("Hello World!\n");
});

server.listen(8000);

console.log("web running at http://127.0.0.1:8000/");
