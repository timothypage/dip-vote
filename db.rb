require 'require_all'
require 'sequel'
require 'sequel/model'
require 'logger'

if ENV["DATABASE_HOST"]
  DB = Sequel.connect(
    adapter: ENV.fetch("DATABASE_ADAPTER"),
    host: ENV.fetch("DATABASE_HOST"),
    database: ENV.fetch("DATABASE_NAME"),
    user: ENV.fetch("DATABASE_USER"),
    password: ENV.fetch("DATABASE_PASSWORD")
  )
else
  DB = Sequel.sqlite('db/app_development.db')
end
DB.loggers << Logger.new(STDOUT)
DB.sql_log_level = :debug
Sequel::Model.db = DB
Sequel::Model.plugin :update_or_create
Sequel::Model.plugin :json_serializer

require_all './models/*'