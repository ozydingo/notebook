Set the commit date on an existing commit:
`GIT_COMMITER_DATE="Mon 04 Feb 2019 16:00:00 EST" git commit --amend --no-edit --date "Mon 04 Feb 2019 16:00:00 EST"`

Show commit timestamp only
`git show --no-patch --format='%at' $ref`

Show old branches with their last commit date:
```
let thresh="$(date +%s) - 300 * 24 * 60 * 60"; git branch -r | while read ref dummy; do :; git show --no-patch --format='%an;%at;%ar' $ref | REF=$ref THRESH=$thresh ruby -ne 'author, ts, tl = $_.chomp.split(";"); ref=ENV["REF"]; thresh=ENV["THRESH"]; puts "#{ref}\t#{author}\t#{tl}" if ts.to_i < thresh.to_i'; done
```
