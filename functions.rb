require "pg"
require "bcrypt"


load './local_env.rb' if File.exist?('./local_env.rb')

def adding_to_table(arr)

db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
db = PG::Connection.new(db_params)
answer = ""
check = db.exec("SELECT * FROM phonebook_table WHERE phone = '#{arr[-1]}'")

	if check.num_tuples.zero? == false
		answer = "Your Number is already being used"
	else
		answer = "you join this phone book"
		db.exec("insert into phonebook_table(first_name,last_name,address,city,state,zip,phone)VALUES('#{arr[0]}','#{arr[1]}','#{arr[2]}','#{arr[3]}','#{arr[4]}','#{arr[5]}','#{arr[6]}')")
	end
	answer
end


def get_info_database()
	db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
data = []
db = PG::Connection.new(db_params)
 db.exec( "SELECT * FROM phonebook_table" ) do |result|
      result.each do |row|
      	data << row.values
      end
    end
   data
end

def search_data_phone(info)
	db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
	db = PG::Connection.new(db_params)
	check = db.exec("SELECT * FROM phonebook_table WHERE phone = '#{info}'")
	
	if check.num_tuples.zero? == false
			search_answer = check.values
	else
		search_answer = "isnt in phone book"
	end

	end

def search_data_lname(info)
	db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
db = PG::Connection.new(db_params)
check = db.exec("SELECT * FROM phonebook_table WHERE last_name = '#{info}'")
woo = check.num_tuples
if check.num_tuples.zero? == false
	search_answer = check.values
else
	search_answer = "isnt in phone book"
end
end
# get_info_database()


def update_table(info_new,old_phone)
		db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
db = PG::Connection.new(db_params)
	counter = 0
	info_new.each do |arr|
		db.exec("UPDATE phonebook_table SET first_name = '#{arr[0]}' ,last_name = '#{arr[1]}',address = '#{arr[2]}',city = '#{arr[3]}',state = '#{arr[4]}',zip = '#{arr[5]}',phone = '#{arr[6]}'WHERE phone = '#{old_phone[counter]}'")
		counter =+ 1
	end
end

def delete_from_table(delete_info)
	db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
db = PG::Connection.new(db_params)
	arr = []
	delete_info.each do |row|
		woo = row.split(',')
		arr << woo
	end
	# delete_split = delete_info.split(',')
	# delete_slice = delete_slice.slice(7).to_a
	arr.each do |row|
		delete_num = row[-1]
		db.exec("DELETE FROM phonebook_table WHERE phone = '#{delete_num}'")
	end

end


def check_creds?(user,pass)
	db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
db = PG::Connection.new(db_params)
 
check = db.exec("SELECT*FROM creds_table WHERE username = '#{user}'")
 		if check.num_tuples.zero? == false
 			check_val = check.values.flatten
 			check_pass = BCrypt::Password.new(check_val[1])

  			if check_pass == pass
 				true
 			else
 				false
 			end
 		else
 			false
 		end
end


def add_to_login(user,pass)
		db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['user'],
	password: ENV['password']
}
db = PG::Connection.new(db_params)
 check = db.exec("SELECT*FROM creds_table WHERE username = '#{user}'")
	message = ""
	if check.num_tuples.zero? == false
		message = "Username Already Taken"
	else
		message = "Login Created"
	pass_b = BCrypt::Password.create "#{pass}"
	db.exec("insert into creds_table(username,pass)VALUES('#{user}','#{pass_b}')")
	end
	message
end