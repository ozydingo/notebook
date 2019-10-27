## Post body & params behavior

### Summary
`axios.get(url, {data:, params:})`
`axios.post(url, body, {data:, params:})`

### GET
`axios.get("http://localhost:3000/tests")`
`axios.get("http://localhost:3000/tests", {x: 1})`
`axios.get("http://localhost:3000/tests", {body: 1})`

```
===============
Raw post:
---------------

---------------
Method: GET
Params: {"controller"=>"tests", "action"=>"index"}
Request params: {}
Query params: {}
Body:
===============
```

`axios.get("http://localhost:3000/tests", {params: {x: 1}})`

```
===============
Raw post:
---------------

---------------
Method: GET
Params: {"x"=>"1", "controller"=>"tests", "action"=>"index"}
Request params: {}
Query params: {"x"=>"1"}
Body:
===============
```

`axios.get("http://localhost:3000/tests", {data: {x: 1}})`

```
===============
Raw post:
---------------
{"x":1}
---------------
Method: GET
Params: {"x"=>1, "controller"=>"tests", "action"=>"index", "test"=>{"x"=>1}}
Request params: {"x"=>1, "test"=>{"x"=>1}}
Query params: {}
Body: {"x":1}
===============
```

### POST

`axios.post("http://localhost:3000/tests")`

```
===============
Raw post:
---------------

---------------
Method: POST
Params: {"controller"=>"tests", "action"=>"create"}
Request params: {}
Query params: {}
Body:
===============
```

`axios.post("http://localhost:3000/tests", {x: 1})`

```
===============
Raw post:
---------------
{"x":1}
---------------
Method: POST
Params: {"x"=>1, "controller"=>"tests", "action"=>"create", "test"=>{"x"=>1}}
Request params: {"x"=>1, "test"=>{"x"=>1}}
Query params: {}
Body: {"x":1}
===============
```

`axios.post("http://localhost:3000/tests", {x: 1}, {params: {a: 2}})`

```
===============
Raw post:
---------------
{"x":1}
---------------
Method: POST
Params: {"x"=>1, "a"=>"2", "controller"=>"tests", "action"=>"create", "test"=>{"x"=>1}}
Request params: {"x"=>1, "test"=>{"x"=>1}}
Query params: {"a"=>"2"}
Body: {"x":1}
===============
```

`axios.post("http://localhost:3000/tests", {x: 1}, {data: {a: 2}})`

```
===============
Raw post:
---------------
{"a":2,"x":1}
---------------
Method: POST
Params: {"a"=>2, "x"=>1, "controller"=>"tests", "action"=>"create", "test"=>{"a"=>2, "x"=>1}}
Request params: {"a"=>2, "x"=>1, "test"=>{"a"=>2, "x"=>1}}
Query params: {}
Body: {"a":2,"x":1}
===============
```

`axios.post("http://localhost:3000/tests", "message")`
`axios.post("http://localhost:3000/tests", "message", {data: {a: 2}})`

```
===============
Raw post:
---------------
message
---------------
Method: POST
Params: {"message"=>nil, "controller"=>"tests", "action"=>"create"}
Request params: {"message"=>nil}
Query params: {}
Body: message
===============
```

`axios.post("http://localhost:3000/tests", "message", {params: {x: 1}})`

```
===============
Raw post:
---------------
message
---------------
Method: POST
Params: {"message"=>nil, "x"=>"1", "controller"=>"tests", "action"=>"create"}
Request params: {"message"=>nil}
Query params: {"x"=>"1"}
Body: message
===============
```

`axios.post("http://localhost:3000/tests", {params: {x: 1}})`

```
===============
Raw post:
---------------
{"params":{"x":1}}
---------------
Method: POST
Params: {"params"=>{"x"=>1}, "controller"=>"tests", "action"=>"create", "test"=>{"params"=>{"x"=>1}}}
Request params: {"params"=>{"x"=>1}, "test"=>{"params"=>{"x"=>1}}}
Query params: {}
Body: {"params":{"x":1}}
===============
```
