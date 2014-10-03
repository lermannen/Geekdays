require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'

require_relative 'db'

class Geekdays < Sinatra::Base
  include DateValidation

  get '/' do
    @events = DB[:events].all
    p @events
    erb :index
  end

  post '/' do
    events = DB[:events]
    params[:year] = '0000' if params[:year] == '*'

    date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    events.insert(date: date, type: params[:type], text: params[:text], url: params[:url])

    redirect '/'
  end

  run! if app_file == $PROGRAM_NAME # If we run using 'ruby app.rb'

end