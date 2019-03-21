# gcloud

## Cheatsheet

- List configs: `gcloud config configurations list`
- Use a names config:
  - `gcloud --configuration=$NAME ...`
  - `CLOUDSDK_ACTIVE_CONFIG_NAME=$NAME gcloud ...`
  - `CLOUDSDK_ACTIVE_CONFIG_NAME=$NAME gsutil ...`

## Notes

`gsutil` is a separate utility to the rest of gcloud. It does not support a `--configuration` flag.
