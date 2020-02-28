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
  Float :avg_overall
  Float :avg_sound
  Float :avg_vibe
  Float :avg_payout
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :venue_id
  String :reviewer_name
  Integer :overall_rating
  Integer :sound_rating
  Integer :vibe_rating
  Integer :payout_rating
  String :comments, text: true
end

# Insert initial (seed) data
venues_table = DB.from(:venues)

venues_table.insert(venue_name: "Martyrs", 
                    address: "3855 N Lincoln Ave, Chicago, IL 60613",
                    website: "http://martyrslive.com/",
                    email: "bruce@martyrslive.com",
                    phone: "(773) 404-9494",
                    avg_overall: 5,
                    avg_sound: 5,
                    avg_vibe: 5,
                    avg_payout: 5)

venues_table.insert(venue_name: "Tonic Room", 
                    address: "2447 N Halsted St, Chicago, IL 60614",
                    website: "https://tonicroom.ticketfly.com/",
                    email: "booking@harmonicadunn.com",
                    phone: "(773) 248-8400",
                    avg_overall: 4.25,
                    avg_sound: 4.5,
                    avg_vibe: 4,
                    avg_payout: 4)

venues_table.insert(venue_name: "The Store", 
                    address: "2002 N Halsted St, Chicago, IL 60614",
                    website: "https://storefm.com/",
                    email: "contact@storefm.com",
                    phone: "(773) 327-7766",
                    avg_overall: 3,
                    avg_sound: 2.5,
                    avg_vibe: 4,
                    avg_payout: 3)
