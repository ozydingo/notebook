require 'warden'

require './application'
require './logout'

main_app = Application.new
fallback_app = Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ["Nice rack."]] }
failure_app = Proc.new { |env| ['401', {'Content-Type' => 'text/html'}, ["UNAUTHORIZED"]] }

use Rack::Session::Cookie, secret: "MY_SECRET"

protected_app = Rack::Builder.new do
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == ['admin', 'abc123']
  end

  run main_app
end

special_app = Rack::Builder.new do
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == ['admin', 'abc123']
  end

  run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['Extra Special']] }
end

adminable = Rack::Builder.new do
  map "/admin" do
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      [username, password] == ['admin', 'abc123']
    end
    run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['Admin area']] }
  end

  run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['Not admin area']] }
end


map "/protected" do
  run protected_app
end

map "/also_protected" do
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == ['admin', 'abc123']
  end
end

map "/special" do
  run special_app
end

map "/adminable" do
  run adminable
end

map("/logout") { use Logout }

use Warden::Manager do |manager|
  manager.default_strategies :password, :basic
  manager.failure_app = failure_app
end

run main_app
