### PGLConnectionBad: connection is closed

Error while running rspec:

```
An error occurred while loading rails_helper.
Failure/Error: ActiveRecord::Migration.maintain_test_schema!

PG::ConnectionBad:
  connection is closed
```

Resource: https://medium.com/@yutafujii_59175/pg-connectionbad-could-not-connect-to-server-no-such-file-or-directory-9a2eada16f9

Comment out line `ActiveRecord::Migration.maintain_test_schema!` in spec/rails_helper.rb

### TemplateError: wrong number of arguments

https://github.com/rspec/rspec-rails/issues/2086

Upgrade to rpsec 4.0.0.beta3
