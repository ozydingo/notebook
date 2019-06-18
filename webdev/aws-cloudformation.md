# CloudFormation

## Template structure

A template appears to have the following structure in a miminal implementation:

* `Globals` - global env vars
* `Parameters` - maybe invocation/ CLI params?
* `Resources` - a list of AWS resources (S3 Buckets, IAM Roles, Lambdas, Custom, etc) to instantiate. This is the only required data key.
* `Outputs` - Returned values for `aws cloudformation describe-stacks`

### Template Resources

Resources are specified as a key-value data structure, where the key is a name for the resource. The value is a key-value map where keys might include:

* `Type` (required)
* `Description`
* `Properties`

Resource types and their associated properties can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)

Additional resource attributes are [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-product-attribute-reference.html), including CreationPolicy and DeletionPolicy, Metadata, DependsOn, etc.

### Resource References

Properties are usually Strings or key-value maps. Values can refer to other resources using the [Ref](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html) function, as in `{ "Ref": resource_name }` (json) or `!Ref $resource_name` (yaml).

A Ref value can be an element in an array of other String or Ref values.

### Parameters

The Ref function can also refer to parameter values by specifying the parameter name (instead of a resource name). Parameters are specified in the `Parameters` key at the root of the template. The Ref docs imply that param names are matched before resource names, but don't say this explicitly.

To access an attribute of a resource, instead of the resource as a whole as is done by Ref, use the [GetAtt](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-getatt.html) function.

Parameters can have a default value specified, otherwise they are required.

String parameters can be validated using the keys MinLength, MaxLength, Default, AllowedValues, and AllowedPattern. Numbers: MinValue, MaxValue, Default, and AllowedValues.

Set NoEcho to true to hide sensitive parameter values from inspection.

### Mappings

You can define a `Mappings` key at the root level of a template to provide lookup tables; e.g. to select values based on region or parameters. Access mappings using the [FindInMap](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-findinmap.html) function: `{ "Fn::FindInMap" : [map_name, outer_key, inner_key]}` (json) or ` !FindInMap [ $map_name, $outer_key, $inner_key ]` (yaml). Both inner and outer keys seem to be required, so structure your data that way if that's the case even if you only need one level.

### Other

Fn::Join(delim, items_array) and [more functions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html)

The `Transforms` key can specify preprocessing macros to be applied to the template. E.g. `Transform: 'AWS::Serverless-2016-10-31'` is an AWS-hosted transform that allows, for example, a simpler specification of `AWS::Serverless::Function` resource types to be expanded into `AWS::Lambda::Function` and a corresponding `AWS::IAM::Role`. See more [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/transform-aws-serverless.html). The `AWS::Include` macro can import boilerplate template data from a specified source.

You can also use modularized templates by specifying a [AWS::CloudFormation::Stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-stack.html) resource.

## Hello, World

```yaml
Resources:
  HelloBucket:
    Type: AWS::S3::Bucket
```

## CLI

Use `aws cloudformation deploy --stack-name $stack_name --template-file $template_file` to deploy a template ([ref](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/deploy/index.html)). This template cannot refer to any local resources, such as local files for lambda code.

If you have such local files, use `aws cloudformation package --template_file $template_file --s3_bucket $s3_bucket` ([ref](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/package.html)) to upload these resources to the s3 bucket and output a master template that refers to the uploaded locations. You can then deploy the resulting template.
