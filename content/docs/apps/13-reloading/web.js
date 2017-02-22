var http = require("http");

var client = require("./redis-client.js");

var server = http.createServer(function(request, response) {
  console.log(request.method, request.url)

  client.rpush("queue", JSON.stringify(request.headers));

  response.writeHead(200, {
    "Content-Type": "text/plain"
  });
  response.end("Hello World!!\n");
});

server.listen(8000);

console.log("web running at http://127.0.0.1:8000/");
