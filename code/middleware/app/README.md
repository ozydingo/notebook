# README

## Middleware with a views

The middleware at lib/middleware/middle_view is mounted in `config/routes.rb` at `/views`. This results in a call to this middleware when a request is made to `#{ROOT}/views`. This middleware uses its own path to locate the `views` folder, using `Rack::Static` to server files therein.

* Start `rails s`
* Navigate to localhost:3000/views to see this middleware in action.

## Middleware with your application model

The middleware located at `lib/middleware/users.rb` demonstrates using both `Rails.logger` and the app-specific `User` model, which is an `ActiveRecord::Base` model. This "just works" (tm).
