var redis = require("redis");

module.exports = redis.createClient({
  retry_strategy: function(options) {
    console.log("redis client retry with backoff");

    if (options.total_retry_time > 1000 * 60 * 60) {
      return new Error("Retry time exhausted");
    }

    return Math.max(options.attempt * 100, 3000);
  },
  url: process.env.REDIS_URL
});
