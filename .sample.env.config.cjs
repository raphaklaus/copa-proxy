module.exports = {
  apps : [
      {
        name: "copa-proxy",
        script: "./index.js",
        env: {
          "USERNAME": "user",
          "PASSWORD": "pass",
        }
      }
  ]
}
