require "sinatra"
require "pg"
load './local_env.rb' if File.exist?('./local_env.rb')

db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
db = PG::Connection.new(db_params)

get "/" do
	erb :get_info
end

post "/got_info" do
info[] << params[:fname]
info[] << params[:lname]
info[] << params[:city]
info[] << params[:state]
info[] << params[:zip]
info[] << params[:phone]

end
