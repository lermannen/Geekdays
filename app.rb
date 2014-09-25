require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'

require 'sequel'
require 'sqlite3'

module DateValidation
  def validate(year, month, day)
    begin
      date = Date.new(year, month, day)
      return true
    rescue ArgumentException
      return false
    end
  end
end

DB = Sequel.sqlite # Memory database

DB.create_table(:events) do
  primary_key :id
  Date :date, :null=>false
  String :text, :null=>false
  String :type, :null=>false
  String :url, :null=>false
end

class Geekdays < Sinatra::Base
  get '/' do
    @events = DB[:events].all
    p @events
    erb :index
  end

  post '/' do
    events = DB[:events]
    params[:year] = '0000' if params[:year] == '*'
  
    date = "#{params[:year]}-#{params[:month]}-#{params[:day]}" if DateValidation.validate(params[:year],params[:month],params[:day])
    events.insert(date: date, type: params[:type], text: params[:text], url: params[:url])

    redirect '/'
  end

  run! if app_file == $PROGRAM_NAME # If we run using 'ruby app.rb'

end