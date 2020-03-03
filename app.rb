# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

venues_table = DB.from(:venues)
reviews_table = DB.from(:reviews)

get "/" do
    puts venues_table.all
    @venues = venues_table.all
    @reviews_table = DB.from(:reviews)

    view "venues"
end

get "/venues/:id" do
    @venue = venues_table.where(id: params[:id]).first
    @reviews = reviews_table.where(venue_id: @venue[:id])
    @avg_overall = reviews_table.where(venue_id: @venue[:id]).avg(:overall_rating)
    @avg_sound = reviews_table.where(venue_id: @venue[:id]).avg(:sound_rating)
    @avg_vibe = reviews_table.where(venue_id: @venue[:id]).avg(:vibe_rating)
    @avg_payout = reviews_table.where(venue_id: @venue[:id]).avg(:payout_rating)
    view "venue"
end

get "/venues/:id/reviews/new" do
    @venue = venues_table.where(id: params[:id]).first
    view "new_review"
end

get "/venues/:id/reviews/confirm" do
    reviews_table.insert(venue_id: params["id"],
                        reviewer_name: params["reviewer_name"],
                        overall_rating: params["overall_rating"],
                        sound_rating: params["sound_rating"],
                        vibe_rating: params["vibe_rating"],
                        payout_rating: params["payout_rating"],
                        comments: params["comments"])
    view "reviews_confirm"
end

get "/venues/new" do
    view "new_venue"
end

get "/venues/confirm" do
    venues_table.insert(venue_name: params["venue_name"],
                        address: params["address"],
                        email: params["email"],
                        phone: params["phone"],
                        website: params["website"])
    view "venue_confirm"
end

get "/users/new" do
    view "new_user"
end

get "/logins/new" do
    view "new_login"
end
