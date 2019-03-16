require 'require_all'
require 'sinatra'
require 'sinatra/json'
require 'jwt'
require 'sysrandom/securerandom'

require './db'

enable :sessions

# changing this will invalidate any active sessions
set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

# changing this will invalidate all login tokens
signing_secret = ENV.fetch('TOKEN_SIGNING_SECRET') { SecureRandom.hex(64) }

logger = Logger.new(STDOUT)

get "/" do
  @contestants = Contestant.all
  erb :index
end

post "/login-by-email" do

  lowercase_email = params[:email] && params[:email].downcase

  if (user = User.find(email: lowercase_email))
    token = JWT.encode params[:email], signing_secret, "HS256"

    logger.info "received login request from #{params[:email]}"
    logger.info "login: http://localhost:4567/login?token=#{token}"
  else
    logger.info "someone tried to login with email: #{lowercase_email}, but that user doesn't exist"
  end

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

# application/json
post "/vote" do
  halt 401 unless session[:email] # security!

  payload = JSON.parse request.body.read

  Vote.update_or_create({email: session[:email]}, dip: payload["dip"]).to_json
end

get "/voted" do
  erb :voted
end