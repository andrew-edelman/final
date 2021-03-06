# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :venues do
  primary_key :id
  String :venue_name
  String :address
  String :website
  String :email
  String :phone
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :venue_id
  foreign_key :user_id
  Integer :overall_rating
  Integer :sound_rating
  Integer :vibe_rating
  Integer :payout_rating
  String :comments, text: true
end

DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
venues_table = DB.from(:venues)

venues_table.insert(venue_name: "Martyrs", 
                    address: "3855 N Lincoln Ave, Chicago, IL 60613",
                    website: "http://martyrslive.com/",
                    email: "bruce@martyrslive.com",
                    phone: "(773) 404-9494")

venues_table.insert(venue_name: "Tonic Room", 
                    address: "2447 N Halsted St, Chicago, IL 60614",
                    website: "https://tonicroom.ticketfly.com/",
                    email: "booking@harmonicadunn.com",
                    phone: "(773) 248-8400")

venues_table.insert(venue_name: "The Store", 
                    address: "2002 N Halsted St, Chicago, IL 60614",
                    website: "https://storefm.com/",
                    email: "contact@storefm.com",
                    phone: "(773) 327-7766")

users_table = DB.from(:users)

users_table.insert(name: "Anonymous", 
                    email: "anonymous@musiciansguide.com",
                    password: "anonymous")