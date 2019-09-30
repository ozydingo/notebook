const QueryBuilder = require('./lib/query-builder');

const builder = new QueryBuilder();

builder.widget({id: 123}, 'id, type, user { id, name }');
builder.box({id: 42}, 'size, location { name, long, lat } }');

console.log(builder.requestData())
