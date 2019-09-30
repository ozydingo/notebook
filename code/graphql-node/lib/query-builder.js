class QueryBuilder {
  constructor() {
    this.query = '';
    this.variables = {};
    this.variableTypes = {};
    this.variableIndex = 0;
  }

  // Output fully-formed request data for HTTP request
  requestData() {
    return {
      query: `query ${this.declaredVariables()} { ${this.query} }`,
      variables: JSON.stringify(this.variables),
    }
  }

  // Declare a new variable and its type with a specific value
  // Append '_NUMBER' to each variable name, where NUMBER auto0-increments
  // to guarantee uniqueness
  declare(name, type, value) {
    if (value === undefined) { return; }

    const uniqueName = `${name}_${this.variableIndex}`;
    this.variableTypes[uniqueName] = type;
    this.variables[uniqueName] = value;
    this.variableIndex = this.variableIndex + 1
    return uniqueName;
  }

  // Helper method to remove undefined keys in an Object
  removeUndefined(queryVariables) {
    const keys = Object.keys(queryVariables).filter(key =>
      queryVariables.hasOwnProperty(key) && queryVariables[key] !== undefined
    )
    return Object.fromEntries(keys.map(key => [key, queryVariables[key]]));
  }

  // Construct a list of declared variable types for the entire operation
  // e.g. `"($fileId: ID!, $name: String)"`
  declaredVariables() {
    if (Object.keys(this.variables).length === 0) { return ''; }
    return '(' +
      Object.keys(this.variables).filter(key =>
        this.variables.hasOwnProperty(key)
      ).map(key =>
        `$${key}: ${this.variableTypes[key]}`
      ).join(', ') + ')';
  }

  // Construct a list of args for a single queried field
  // e.g. `"(id: $fileId, name: $name)"`
  args(queryVariables) {
    const values = this.removeUndefined(queryVariables);
    return '(' +
      Object.keys(values).filter(key =>
        values.hasOwnProperty(key)
      ).map(key =>
        `${key}: $${queryVariables[key]}`
      ).join(', ') + ')';
  }

  // Add the widget query
  widget({ id }, fields) {
    const vars = {
      id: this.declare("id", "ID!", id)
    };
    this.query += `widget ${this.args(vars)} { ${fields} } `;
  }

  // Add the box query
  box({ id }, fields) {
    const vars = {
      fileId: this.declare("id", "ID!", id)
    };
    this.query += `box ${this.args(vars)} { ${fields} } `;
  }
}

module.exports = QueryBuilder
