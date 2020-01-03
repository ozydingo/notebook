// Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

const AWS = require('aws-sdk');

const ddb = new AWS.DynamoDB.DocumentClient({ apiVersion: '2012-08-10' });

const { TABLE_NAME } = process.env;

exports.handler = async (event, context) => {
  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
    apiVersion: '2018-11-29',
    endpoint: event.requestContext.domainName + '/' + event.requestContext.stage
  });

  const body = JSON.parse(event.body);
  if (!body.user_id) {
    return { statusCode: 401, body: "Parameter user_id required" };
  }
  const userId = String(body.user_id);

  const params = {
    TableName : TABLE_NAME,
    ProjectionExpression: 'connectionId',
    FilterExpression : 'userId = :user_id',
    ExpressionAttributeValues : {':user_id' : userId}
  };

  let connectionData;

  try {
    connectionData = await ddb.scan(params).promise();
  } catch (e) {
    return { statusCode: 500, body: e.stack };
  }

  const postData = body.data;

  const postCalls = connectionData.Items.map(async ({ connectionId }) => {
    try {
      await apigwManagementApi.postToConnection({ ConnectionId: connectionId, Data: postData }).promise();
    } catch (e) {
      if (e.statusCode === 410) {
        console.log(`Found stale connection, deleting ${connectionId}`);
        await ddb.delete({ TableName: TABLE_NAME, Key: { connectionId } }).promise();
      } else {
        throw e;
      }
    }
  });

  try {
    await Promise.all(postCalls);
  } catch (e) {
    return { statusCode: 500, body: e.stack };
  }

  return { statusCode: 200, body: 'Data sent.' };
};
