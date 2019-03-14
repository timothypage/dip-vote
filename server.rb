require 'require_all'
require 'sinatra'
require 'sinatra/json'
require 'jwt'
require 'sysrandom/securerandom'
require 'sequel'
require 'sequel/model'

enable :sessions

set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

signing_secret = ENV.fetch('TOKEN_SIGNING_SECRET') { SecureRandom.hex(64) }

DB = Sequel.sqlite('db/app_development.db')
Sequel::Model.db = DB

require_all './models/*'

get "/" do
  @contestants = Contestant.all
  erb :index
end

post "/login-by-email" do
  token = JWT.encode params[:email], signing_secret, "HS256"

  puts "received login request from #{params[:email]}"
  puts "token generated: #{token}"
  puts "login: http://localhost:4567/login?token=#{token}"

  erb :login_by_email
end

get "/login" do

  email, _jwt_junk = JWT.decode params[:token], signing_secret, true, { algorithm: "HS256" }

  session[:email] = email

  redirect "/vote"
rescue JWT::VerificationError # someones trying some shinanigans
  redirect "/"
end

delete "/session" do
  session.clear
end

get "/vote" do
  redirect "/" unless session[:email] # security!

  erb :vote
end

post "/vote" do
  halt 401 unless session[:email] # security!

  payload = JSON.parse request.body.read

  Vote.create(email: session[:email], dip: payload["dip"])
end

get "/voted" do
  erb :voted
end