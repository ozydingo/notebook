# WAT

[https://www.destroyallsoftware.com/talks/wat](https://www.destroyallsoftware.com/talks/wat)

## Python

Ternary operator: instead of `condition ? value1 : value2`, you have `value1 if condition else value2`

In pdb, `list` command masks `list` class name.

Tuples hiding in plain sight

```
def f():
  {
    'a': 1,
  },

f()
# => ({'a': 1},)
# That's a tuple
```

Unsortable

```
>>> sorted([1,2, 0])
[0, 1, 2]
>>> sorted([1,2,np.nan, 0])
[1, 2, nan, 0]
```

## Javascript

```js
new Date(2019, 8, 01, 12, 13, 14)
//=> 2019-09-01T16:13:14.000Z
```

## Bash

`[-z]`, [`-n`]: I literally have to use a pneumonic each time to remember which one means what.

## Mutli

Sting join:

* Ruby, Javascript: `['foo', 'bar'].join('-')]`
* Python: `'-'.join(['foo', 'bar'])`
* Perl: `join('-', ['foo', 'bar'])`

## OpenCV

```python
output = cv2.rectangle(image, (0, 0), (10, 10), color=(0,0,0))
# => OK
output = cv2.rectangle(image, (0.0, 0), (10, 10), color=(0,0,0))
# ---------------------------------------------------------------------------
# TypeError                                 Traceback (most recent call last)
# <ipython-input-50-200ba873e75b> in <module>
# ----> 1 output = cv2.rectangle(image, (0.0, 0), (10, 10), color=(0,0,0))
#
# TypeError: argument for rectangle() given by name ('color') and position (3)
```

Color tuples are (B G, R) instead of (R, G, B)

More: https://www.learnopencv.com/why-does-opencv-use-bgr-color-format/

## AWS

### Sign-in sessions

After some amount of time, you get logged out. That's a security feature I can accept. To log back in, click a button. No password or reauthentication.

Wat?

### Granting permissions to read an s3 bucket.

* Read s3 from an ElasticBeanstalk app.
  * Permission denied.
* Go into Elastic Beanstalk console, config / security.
  * Can't add new roles here; go into IAM console instead.
* You can modify the service role, but that would grant all EC2 instances the permissions you only want to give this app.
* Instead, create a new role. Also copy over all existing policies on the currently used ec2 role to this new role. Make sure you're using the aws-elasticbeanstalk-ec2 role, not the aws-elasticbeanstalk-service role, duh.
* But how to attach it to the Elastic Beanstalk app in question? What are the resource names for the Elastic Beanstalk resources?
  * Not displayed. You must go to he EC2 console and find the specified instance.
* You cannot tell which instances belongs to the Elastic Beanstalk app.
  * For that, go into the Elastic Beanstalk console and click on the "Health" tab, because that's how you can find out the instance ids of the EC2 instances running under this app. Duh.
* Write the instance IDs down, or get them tattooed on your chest
* Go back to EC2 console, find the instances with the IDs you now have tattooed on your chest.

Oh, and the back button doesn't work when you click into instance because the AWS console does a location update so click back forwards you right back to where you are. And "open in new tab" is not possible because the AWS console intercepts right clicks.

Or you can just grant all EC2 instances full S3 access. This solution is not recommended.

### CloudFormation deploy failure: service limits

* Create a new stack.
  * Deploy failed: "Maximum number of addresses has been reached. Service: EC2", stack is now in state ROLLBACK_COMPLETE.
* Apparently this has something to do with service limits, but AWS wouldn't want to tell you that directly.
* Delete some elastic ip address and try again.
  * No, despite instructions to redeploy a stack in a bad state, you can't actually do that if the first deploy failed.
* Delete, start again.
* Still failing, contact support.
  * Oh, yeah, you are likely running into one of [these](https://console.aws.amazon.com/servicequotas/home?region=us-east-1#!/services/ec2/quotas) service limits
    * This is a page with 13 pages of 20-item tables of EC2-related AWS service limits but no info on what your current values are. Go ahead and figure out which of these 260 items you are exceeding your limit on, then fix it.
* Discover by fluke that you're at your max Security Groups, which is an EC2 concept and listed under the EC2 console, but not listed under EC2 in this service limits page. No, it's listed under RDS management.
* Go to Security Groups (by going to EC2 console), greeted with a list of security groups with opaque ids and no indication of what these are used by.
* Turns out you can find this out, but not in the AWS console. Instead, use the AWS CLI: `aws ec2 describe-network-interfaces --filters Name=group-id,Values=$group_id`.
* Delete a few security groups, try again
  * No, remember, can't redeploy a stack if its first deploy failed.
    * Delete and try again
      * Failed again. Same error.

### Triggering something off of an existing s3 bucket

* Not supported. You can only trigger a Lambda on a bucket event if the bucket was created by the template.
  * Workaround:
    * Deploy without the trigger, then add the trigger later
    * Use an SNS channel instead and have the bucket publish SNS events
