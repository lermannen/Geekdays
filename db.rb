require 'sequel'
require 'pg'

DB = Sequel.connect("postgres://akorling@localhost:5432/geekdays") # ENV['DATABASE_URL'])