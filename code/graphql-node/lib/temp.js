class QueryBuilder {
  constructor() {
    this.query = '';
    this.variables = {};
    this.variableTypes = {};
    this.variableIndex = 0;
  }

  declare(name, type, value) {
    if (value === undefined) { return; }

    const uniqueName = `${name}_${this.variableIndex}`;
    this.variableTypes[uniqueName] = type;
    this.variables[uniqueName] = value;
    this.variableIndex = this.variableIndex + 1
    return uniqueName;
  }

  removeUndefined(queryVariables) {
    const keys = Object.keys(queryVariables).filter(key =>
      queryVariables.hasOwnProperty(key) && queryVariables[key] !== undefined
    )
    return Object.fromEntries(keys.map(key => [key, queryVariables[key]]));
  }

  // Construct a list of declared variable types for the entire operation
  // e.g. `"($fileId: ID!, $name: String)"`
  declaredVariables() {
    return '(' +
      Object.keys(this.variables).filter(key =>
        this.variables.hasOwnProperty(key)
      ).map(key =>
        `$${key}: ${variableTypes[key]}`
      ).join(', ') + ')';
  }

  // Construct a list of args for a single queried field
  // e.g. `"(id: $fileId, name: $name)"`
  args(queryVariables) {
    const values = removeUndefined(queryVariables);
    return '(' +
      Object.keys(values).filter(key =>
        values.hasOwnProperty(key)
      ).map(key =>
        `${key}: $${queryVariables[key]}`
      ).join(', ') + ')';
  }

  file({ id }, fields) {
    const vars = {
      id: this.declare("id", "ID!", id)
    };
    this.query += `file${args(vars)} { ${fields} } `;
  }

  fileActions({ fileId }, fields) {
    const vars = {
      fileId: this.declare("fileId", "ID!", fileId)
    };
    this.query += `fileActions${args(vars)} { ${fields} } `;
  }

  transcript({ fileId, transcriptId}, fields) {
    const vars = {
      fileIdName: this.declare("fileId", "ID!", fileId),
      transcriptIdName: this.declare("transcriptId", "ID", transcriptId),
    }
    this.query += `transcript{args(vars)} { ${fields} } `;
  }
}

class Query {
  constructor(api) {
    this.api = api;
  }

  request({ fields, variableTypes, variables }) {
    this.api.request({
      type: 'query',
      fields, variableTypes, variables
    })
  }

  file({id}, fields) {
    this.request({
      `file(id: $fileId) { ${fields} }`,
      variableTypes: {id: 'ID!'},
      variables: { id },
    })
  }

  fileActions({fileId}, fields) {
    this.request({
      `fileActions(fileId: $fileId) { ${fields} }`,
      variableTypes: {fileId: 'ID!'},
      variables: { fileId },
    })
  }

  transcript({fileId, transcriptId}, fields) {
    this.request({
      `transcript(fileId: $fileId, transcriptId: $transcriptId) { ${fields} }`,
      variableTypes: {fileId: 'ID!', transcriptId: 'ID'},
      variables: { fileId, transcriptId },
    })
  }

}
