axios = require('axios');

class GraphQLClient {

  constructor({ endpoint }) {
    this.endpoint = endpoint;
  }

  requestData({type, fields, variableTypes, variables}) {
    const varDeclaration = variableTypes && (
      '(' + Object.keys(
        variableTypes
      ).filter(key =>
        variableTypes.hasOwnProperty(key)
      ).map(name =>
        `$${name}: ${variableTypes[name]}`
      ).join(', ') + ')'
    );
    return {
      query: `${type}${varDeclaration || ''} {${fields}}`,
      variables: JSON.stringify(variables),
    }
  }

  request({type, fields, variableTypes, variables, headers}) {
    const data = this.requestData({type, fields, variableTypes, variables});
    return axios({
      method: 'POST',
      url: this.endpoint,
      data,
      headers,
    })
  }
}

 module.exports = GraphQLClient;
