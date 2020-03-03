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

reviews_table = DB.from(:reviews)

reviews_table.insert(venue_id: 1,
                    reviewer_name: "Andy", 
                    overall_rating: 4,
                    sound_rating: 4,
                    vibe_rating: 4,
                    payout_rating: 4,
                    comments: "great place!")

reviews_table.insert(venue_id: 2,
                    reviewer_name: "Andy", 
                    overall_rating: 4,
                    sound_rating: 4,
                    vibe_rating: 4,
                    payout_rating: 4,
                    comments: "great place!")                   

reviews_table.insert(venue_id: 3,
                    reviewer_name: "Andy", 
                    overall_rating: 4,
                    sound_rating: 4,
                    vibe_rating: 4,
                    payout_rating: 4,
                    comments: "great place!")
