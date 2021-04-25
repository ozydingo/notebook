use Rack::Static, :urls => [""], :root => 'ui/build', :index => 'index.html'
# run Rack::Static.new(Proc.new {}, :urls => [""], :root => 'ui/build', :index => 'index.html')
run Proc.new { |env| [404, {"Content-Type" => "text/html"}, ["Not Found"]] }
