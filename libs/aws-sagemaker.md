## Authentication

Use AWS profiles to authenticate local sessions with AWS resources:

```py
import boto3
import sagemaker

boto_session = boto3.session.Session(profile_name="research")
sagemaker_session = sagemaker.Session(boto_session)
bucket = sagemaker_session.default_bucket()
```

## Basic operation: PyTorch

Create a PyTorch estimator and call `fit`:

```py
import sagemaker
sagemaker_session = sagemaker.Session()
role = sagemaker.get_execution_role()

from sagemaker.pytorch import PyTorch
pytorch_estimator = PyTorch(
  entry_point='pytorch-train.py',
  source_dir='/path/to/src'
  role = role
  train_instance_type='ml.p3.2xlarge',
  train_instance_count=1,
  framework_version='1.0.0',
  hyperparameters = {'epochs': 20, 'batch-size': 64, 'learning-rate': 0.1})

pytorch_estimator.fit({
  'train': 's3://my-data-bucket/path/to/my/training/data',
  'test': 's3://my-data-bucket/path/to/my/test/data'})
```

The first arg to `sagemaker.pytorch.PyTorch#fit` is a dict of "data channels", which must be a valid `s3://` or `file://` uri. For each, file at the specified location are downloaded into `/opt/ml/input/data/$CHANNEL_NAME`, whose location is accessible in the env variable `SM_CHANNEL_[channel_name]` in the executiion environment.

Note: To use s3 input channels, the sagemaker esecution role must be granted s3 access permissions.

The script specified by the `entry_point` arg is invoked with arguments determined by `hyperparameters`. In this example, the `pytorch-train.py` file might have the following code:

```py
import argparse

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument('--epochs', type=int, default=50)
  parser.add_argument('--batch-size', type=int, default=64)
  parser.add_argument('--learning-rate', type=float, default=0.05)
  args = parser.parse_args()
```

Save your model to the path specified by the env variable `SM_MODEL_DIR`, and save output data to that in `SM_OUTPUT_DATA_DIR`. These paths will get uploaded to an S3 bucket specific to the sagemaker role.
