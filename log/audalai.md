## 2019-05-09

Create new Rails app in `server` folder. Get Rails 6 rc1:

```
echo "gem 'rails', '~> 6.0.0.rc1'" >> Gemfile
bundle install

rails new . --force --skip-bundle
bundle update
```

`rails new` apparently creates a .git folder, so

```
rm -rf .git
```

Install puma-dev, follow instructions.

ERROR: `You must use Bundler 2 or greater with this lockfile.` This may be responsible for downstream errors that are preventing me from running rails s or puma.

Adding `gem 'bundler', '~> 2.0.1'` does not work; `bundler -v` still returns `1.17.2`. But `bundle exec bundler -v` returns `2.0.1`. `bundle exec rails s` still fails:

ERROR: `Webpacker configuration file not found /Users/andrew/code/apps/audalai/server/config/webpacker.yml. Please run rails webpacker:install`

-> `bundle exec rake webpacker:install`

ERROR: `Yarn not installed. Please download and install Yarn from https://yarnpkg.com/lang/en/docs/install/`

-> Remove webpacker, turbolinks from Gemfile. Success.

ERROR:

```
Blocked host: audalai.test

To allow requests to audalai.test, add the following to your environment configuration:
config.hosts << "audalai.test"
```

Add to application.rb, `touch tmp/rextart.txt`. Success. Add `if Rails.env == "development"`.

## 2019-05-10

needing to `bundle exec` everything is a PITA. Try `gem install --default -v2.0.1 bundler`. Then `bundler --version`

ERROR: `Unable to resolve dependency: user requested 'bundler (= 1.17.2)'`

`bundle exec bundler --version`

ERROR: `cannot load such file -- /Users/andrew/.rvm/rubies/ruby-2.6.0/lib/ruby/gems/2.6.0/gems/bundler-2.0.1/exe/bundle`

This is weird:

```
$ gem list bundler

bundler (default: 2.0.1, default: 1.17.2)
```

```
gem install -v1.17.2 bundler
gem uninstall -v1.17.2 bundler
```

ERROR: `Gem 'bundler' is not installed`

```
gem uninstall bundler -v 1.17.2
```

Gives `Successfully uninstalled bundler-1.17.2`, yet the version remains.

```
rvm @global do gem uninstall bundler
rvm all do gem uninstall bundler
rvm 1.9.2,1.9.3 do gem uninstall bundler
rvm 2.6.0 do gem uninstall bundler
```
-- no luck

```
gem update --system
gem uninstall bundler
gem install bundler
```

Still getting 1.17.2 listed as "default", but `bundler --version` gives me 2.0.1 everywhere, and `rails` commands work. Somewhat baffled.

Install graphql and graphiql-rails, following https://mattboldt.com/2019/01/07/rails-and-graphql/

`rails g graphql:object user`, hand-coded the audio type.

## 2019-06-15

Hosting options with examples:

* Reactjs + Google Cloud: https://medium.com/google-cloud/hosting-a-react-js-app-on-google-cloud-app-engine-6d1341b75d8c
* Docker + Reactjs + Google Cloud: https://hackernoon.com/deploy-react-application-using-docker-and-google-cloud-platform-4bc03f9ee1f
* Rails API + React on Google Cloud or Linode: http://nelsonware.com/blog/2019/01/01/patterns-for-conventional-api-rails-apps-on-linode-or-google-cloud-platform-in-2019.html
* Static react deploy: https://medium.com/google-cloud/how-to-deploy-a-static-react-site-to-google-cloud-platform-55ff0bd0f509

https://medium.com/@bruno_boehm/reactjs-ruby-on-rails-api-heroku-app-2645c93f0814 has some good clues

react client is in client folder inside rails app. You npm start from there, where it routes /api requests to localhost:3001, where the rails server is run.

This uses Heroku, which apparently can use the localhost endpoint. Not sure if this is compatible with google cloud app engine style hosting.

The claim is that /public is served by rails. I have it serving the HomeController#index action. Maybe I just need to delete that route, or otherwise figure out how to route something in rails to a static index.html inside /public

Yeah that worked.

So to sum up -- Rails root routes to public/index.html. For a production build, we'll npm build the react app and copy it into public. Push that up to app engine and it should work.

For dev, maybe the same? But why was the blog above using the npm server and rails proxied to port 3001?

Opening index.html directly doesn't work by default (need links to /static folder, but setting "homepage": "/Users/andrew/code/apps/audalai/client/build" in package.json causes it to work!

CORS.

Static build CSS is a little messed up for some reason.

Try: npm run build, copy build/* into public. Set "homepage": "." in `package.json`. Works, but CSS issues persist.

Summary of hosting options:

* Static on a bucket. In the process of testing
* Static from /public served by Rails. This gives conflicting jss class names -- need to understand why, maybe related to server-side rendering.
* Two app engines, Google and/or Heroku, talking to each other. Deploying the client to GAE by default runs in dev mode, but this may be fixable. I could also deploy the client to heroku and the back-end to GAE.

https://github.com/mui-org/material-ui/issues/11628 implies that `withStyles` is responsible for the jss naming conflict. Components using `withStyles` use a separate class name generator, so they conflict.

https://github.com/mui-org/material-ui/issues/8223

Solved -- consolidate `styles` imports from `material-ui` to `material-ui/styles`, avoiding `material-ui/core/styles`. Refactor all components to functional components with hooks.

Deploy to Heroku using the `/public` strategy. Success!

## 2019-06-19

Persist login using `localStorage`. Add an `authenticate` route that returns user info -- this both checks that the auth is still valid and avoids having to store more user data in `localStorage`. However as currently written it flashes the no-user screen for a hot second before the request completes, so we should try to do this prior to the initial diaply, or have a better visual representation.
