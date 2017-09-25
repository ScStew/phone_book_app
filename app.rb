require "sinatra"
require "pg"
require "bcrypt"
require_relative "functions.rb"
enable :sessions
load './local_env.rb' if File.exist?('./local_env.rb')

# db_params = {
# 	host: ENV['host'],
# 	port: ENV['port'],
# 	dbname: ENV['dbname'],
# 	user: ENV['user'],
# 	password: ENV['password']
# }
# db = PG::Connection.new(db_params)

get "/" do
	message = params[:message]
	if message == nil
		message = "Please Login"
	end
	erb :login, locals:{message:message}
end

post "/create_login" do
	redirect "/make_login"
end
get "/make_login" do
	erb :make_login
end

post "/made_login" do
	user = params[:user]
	pass = params[:pass]
	message = add_to_login(user,pass)
	redirect "/?message=" + message
end


post "/login" do
	user = params[:username]
	pass = params[:password]
	if check_creds?(user,pass) == true 
		redirect "/get_info"
	else 
		message = "incorrect username or password"
		redirect "/?message=" + message
	end
end

get "/get_info" do 
	erb :get_info
end


post "/got_info" do
info = params[:info]

info.each do |item|
	item.capitalize!
end

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
		session[:search_answer] = search_data_lname(lname.capitalize!)
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
	choose = params[:choose]
	if session[:info] == nil
		answer = "Didn't Change"
		redirect "/answer_page?answer=" + answer
	else
		if choose == "update"
			redirect "/update_answer?"
		else
			redirect "/delete?"
		end
	end

end

get "/update_answer" do
erb :update, locals:{info:session[:info]}
end

post '/updated' do
	answer = "Info Updated"
  updated_info = params[:info]
	updated_slice = updated_info.each_slice(7).to_a
  info = session[:info]
  old_phone = []
  
  info.each do |row|
  	split = row.split(',')
  	old_phone << split[-1]
  end
   update_table(updated_slice,old_phone)
   redirect "/answer_page?answer=" + answer
end

get "/delete" do
	answer = "Info DELETED"
	deleting_info = session[:info]
	delete_from_table(deleting_info)
	redirect "/answer_page?answer=" + answer
end

