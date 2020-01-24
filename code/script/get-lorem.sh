n=${1-10}
curl -X POST https://lipsum.com/feed/html --data "amount=$n" --data paras=1 --data start=1 | grep '<div id="lipsum"' -A $((n + 1)) | tail +2 | egrep -v '</?p>'
