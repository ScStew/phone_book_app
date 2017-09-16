require "sinatra"
require "pony"
require "pg"
require "bundler/setup"
require "recaptcha"
load ".loval_env.rb" if File.exists?(".local_env.rb")

