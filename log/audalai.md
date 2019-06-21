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
