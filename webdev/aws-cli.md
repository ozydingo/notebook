## EC2

To find a public AMI that is usable with the free plan:

```bash
`aws ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????-x86_64-gp2' 'Name=state,Values=available' --output json`
#=> "i-0233ddf6fa25e370c"

aws ec2 describe-instances --instance-ids i-0233ddf6fa25e370c --query "Reservations[0].Instances[0].PublicIpAddress"
#=> "13.58.50.95"

ssh -i ~/bp/dev/aws/devenv-key.pem ec2-user@13.58.50.95
```

Note - the `describe-images` command omits the mysterioius `jq` command in the AWS instructions that is not available on OS X.

## S3

```
aws s3api create-bucket --bucket andrew-fidgetology-test --region us-east-1
aws s3api delete-bucket --bucket andrew-fidgetology-test --region us-east-1
```

## Profiles

Note the difference: config uses `profile` whereas credentials does not.

~/.aws/config  
```
[profile sandbox]
region = us-east-1

[profile prod]
region = us-east-1
```

~/.aws/credentials  
```
[sandbox]
aws_access_key_id = [**REDACTED**]
aws_secret_access_key = [**REDACTED**]

[prod]
aws_access_key_id = [**REDACTED**]
aws_secret_access_key = [**REDACTED**]
```

## Security Groups

To see the network interfaces that use a security group:

```
group_id=sg-030d6d5810616ba2e
aws ec2 describe-network-interfaces --query="NetworkInterfaces[0].Status" --filters Name=group-id,Values=$group_id
```
