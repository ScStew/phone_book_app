require "sinatra"
require "pg"
require_relative "functions.rb"
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
info = params[:info]
answer = adding_to_table(info)
redirect "/answer_page?answer=" + answer
end

get "/answer_page" do
	answer = params[:answer]
	phone_book = get_info_database()
	erb :answer_page, locals:{answer:answer,phone_book:phone_book}

end