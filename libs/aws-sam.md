# AWS Serverless Application Model

Read https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md
[Globals](https://github.com/awslabs/serverless-application-model/blob/master/docs/globals.rst), such as timeout, env vars, runtime, etc, apply to all resources therein.

Reosurce types include

* AWS::Serverless::Function
* AWS::Serverless::Api
* AWS::Serverless::Application
* AWS::Serverless::SimpleTable
* AWS::Serverless::LayerVersion

Limitation: S3 can only be used as an event source to a resource when both are specified in the same template.
