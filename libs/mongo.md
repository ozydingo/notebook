## CRUD

```
use <database>
db.widgets.insertOne({...})
db.widgets.insertMany([{...}, {...}, ...])
db.widgets.find()
```

Collections ca also be accessed using `getCollection`

```
db.getCollection("widgets").find()
```

Equality shorthand

```
db.<cllection>.find({<field>: <value>, ...})
```

e.g.

```
db.inventory.find({status: "A", item: "postcard"} ).pretty()
```

Operators

```
db.<collection>.find({<field>: {<operator>: <value>}})
```

e.g.

```
db.inventory.find({status: {$in: ["A", "D"]}} ).pretty()
```

Combine operators

```
db.inventory.find( {qty: { $gt: 40, $lt: 50 } } ).pretty()
```

OR

```
db.<collection>.find({$or: [cond1, cond2, ...]})
```

### Querying nested fields

Match an exact field value:

```
db.inventory.find( { size: { h: 14, w: 21, uom: "cm" } } )
```

vs a nested field

```
db.inventory.find( { "size.h": 14 })
```

Note that for exact matches, the field order mattters. The following does *nnot* return the same match as the exact match example above:

```
db.inventory.find( { size: { w: 21, h: 14, uom: "cm" } } )
```

### Querying array values

Match an entire array

```
db.inventory.find( { tags: ["red", "black"] } )
```

Match arrays that contains elements (and may contain other elements)

```
db.inventory.find( { tags: { $all: ["red", "black"] } } )
```

Match an array containing a single element

```
db.inventory.find( { tags: "red" } )
// equivalent to db.inventory.find( { tags: { $all: ["red"] } } )
```

Combined operators match elements that *in any combination* match the query

```
db.inventory.find( { dim_cm: { $gt: 15, $lt: 20 } } )
// can return an item with an array dim_cm: [20, 12]
// => { "_id" : ObjectId("6029517c079f0f48ebc500c2"), "item" : "journal", "qty" : 25, "tags" : [ "blank", "red" ], "dim_cm" : [ 14, 21 ] }
//    { "_id" : ObjectId("6029517c079f0f48ebc500c3"), "item" : "notebook", "qty" : 50, "tags" : [ "red", "blank" ], "dim_cm" : [ 14, 21 ] }
//    { "_id" : ObjectId("6029517c079f0f48ebc500c4"), "item" : "paper", "qty" : 100, "tags" : [ "red", "blank", "plain" ], "dim_cm" : [ 14, 21 ] }
//    { "_id" : ObjectId("6029517c079f0f48ebc500c6"), "item" : "postcard", "qty" : 45, "tags" : [ "blue" ], "dim_cm" : [ 10, 15.25 ] }
```

Vs finding a item whose array field contains an element that matches all query operators using `$elemMatch`

```
db.inventory.find( { dim_cm: { $elemMatch: { $gt: 15, $lt: 20 } } } )
// => { "_id" : ObjectId("6029517c079f0f48ebc500c6"), "item" : "postcard", "qty" : 45, "tags" : [ "blue" ], "dim_cm" : [ 10, 15.25 ] }
```

Query by index position using index as a field

```
db.inventory.find( { "dim_cm.1": { $gt: 25 } } )
```

Querying by array length using the `$size` operator

```
db.inventory.find( { "tags": { $size: 3 } } )
```

### Querying nested arrays of documents

Query for a item with an exact matching document in array field `instock`

```
db.inventory.find( { "instock": { warehouse: "A", qty: 5 } } )
```

Matching an item with a document in the array that matches all conditions:

```
db.inventory.find( { instock: { $elemMatch: { warehouse: "A", qty: 5 } } } )
```

Matching an item with documents in the array matching the query *in any combination*

```
db.inventory.find( { "instock.warehouse": "A", "instock.qty": 5 } )
```

### Projection

```
db.<collection>.find(<query>, <projection>)
```

e.g.

```
db.inventory.find({}, {item: 1})
```

Supress a default field:

```
db.inventory.find({}, {_id: 0, item: 1})
```

Include all fields except

```
db.inventory.find({}, {_id: 0, status: 0})
```

### Operators

```
$eq
$in
$and
$or
$exists
```

### Updates

```
db.collection.updateOne(<filter>, <update>, <options>)
db.collection.updateMany(<filter>, <update>, <options>)
db.collection.replaceOne(<filter>, <update>, <options>)
```

Updating one / many using `$set` and `$currentDate`

```
db.inventory.updateMany(
   { "qty": { $lt: 50 } },
   {
     $set: { "size.uom": "in", status: "P" },
     $currentDate: { lastModified: true }
   }
)
```

Replace an entire document

```
db.inventory.replaceOne(
  { "qty": { $lt: 50 } },
  { item: "paper", instock: [ { warehouse: "A", qty: 60 }, { warehouse: "B", qty: 40 } ] }
)
```

Option `upsert: true` causes an update to create a document if none were found.

### Delete

```
db.<collection>.deleteMany()
db.<collection>.deleteOne()
```

### Bulk Write

```
db.<collecttion>.bulkWrite([operation1, operation2, ...])
```

## DB Commands

Commands are docuemnts, like

```
{isMaster: 1}
```

Responses look like

```
{
	"ismaster" : true,
	"maxBsonObjectSize" : 16777216,
	"maxMessageSizeBytes" : 48000000,
	"maxWriteBatchSize" : 100000,
	"localTime" : ISODate("2021-02-14T15:41:00.137Z"),
	"logicalSessionTimeoutMinutes" : 30,
	"connectionId" : 1,
	"minWireVersion" : 0,
	"maxWireVersion" : 8,
	"readOnly" : false,
	"ok" : 1
}
```
