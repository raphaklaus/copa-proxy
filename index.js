import { Server } from 'proxy-chain';

console.log("user is:", process.env.USERNAME)

const server = new Server({
  port: 3000, verbose: true, prepareRequestFunction: ({ username, password}) => {

    return {
      requestAuthentication: username !== process.env.USERNAME || password !== process.env.PASSWORD,
      failMsg: 'Bad username or password, please try again.',
    }
  }
});

server.listen(() => {
  console.log(`Proxy server is listening on port ${3000}`);
});
