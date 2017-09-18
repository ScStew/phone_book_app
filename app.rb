require "sinatra"
require "pg"
require_relative "functions.rb"
enable :sessions
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


post "/search" do
	lname = params[:lname]
	phone = params[:phone]
	
	if phone == "" and lname == ""
		session[:search_answer] = "Need search term"
	elsif phone == ""
		session[:search_answer] = search_data_lname(lname)
	else
		session[:search_answer] = search_data_phone(phone)
	end
	redirect "/search_answer?"
end

get "/search_answer" do

erb :search_page, locals:{search_answer:session[:search_answer]}
end

post "/update" do
session[:info] = params[:info]

redirect "/update_answer?"

end

get "/update_answer" do
erb :update, locals:{info:session[:info]}
end