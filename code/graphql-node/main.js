const axios = require('axios');
const GraphQLClient = require('./lib/graphql-client');

const client = new GraphQLClient({endpoint: "http://account.3play.test/data"});
const options = {
  type: 'query',
  fields: 'file(id: $fileId) { name } ',
  variables: {fileId: 12345},
  variableTypes: {fileId: 'ID!'}
};

const data = client.requestData(options);
console.log("Data:", data);

client.request({
  ...options,
  headers: {
    Cookie: process.env.cookie,
  }
}).then(res =>
  console.log(res.data)
).catch(err =>
  console.error(err)
)
