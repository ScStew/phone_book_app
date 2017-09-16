require "sinatra"
require "pony"
require "pg"
require "bundler/setup"
require "recaptcha"
load ".loval_env.rb" if File.exists?(".local_env.rb")

db_params = {
	host: ENV["host"]
	port: ENV["port"]
	dbname: ENV["dbname"]
	user: ENV["user"]
	password: ENV["password"]
}

db = PG::Connection.new(db_params)


}