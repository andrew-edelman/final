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
users_table = DB.from(:users)

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

get "/" do
    puts venues_table.all
    @venues = venues_table.all
    @reviews_table = DB.from(:reviews)

    view "venues"
end

#for the google maps API on this view I just dropped in the address already in the DB directly in to the iframe instead of using geocoder to convert the address to lat-long since that seemed unnecessary?
get "/venues/:id" do
    @venue = venues_table.where(id: params[:id]).first
    @reviews = reviews_table.where(venue_id: @venue[:id])
    @users_table = users_table
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
    if @current_user == nil
        reviews_table.insert(venue_id: params["id"],
                            user_id: 1,
                            overall_rating: params["overall_rating"],
                            sound_rating: params["sound_rating"],
                            vibe_rating: params["vibe_rating"],
                            payout_rating: params["payout_rating"],
                            comments: params["comments"])
    else   
        reviews_table.insert(venue_id: params["id"],
                            user_id: session["user_id"],
                            overall_rating: params["overall_rating"],
                            sound_rating: params["sound_rating"],
                            vibe_rating: params["vibe_rating"],
                            payout_rating: params["payout_rating"],
                            comments: params["comments"])
    end
    view "reviews_confirm"
end

get "/venue/new" do
    view "new_venue"
end

get "/venue/new/confirm" do
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

get "/users/create" do
    users_table.insert(name: params["name"], email: params["email"], password: BCrypt::Password.create(params["password"]))
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    puts params
    email_address = params["email"]
    password = params["password"]

    @user = users_table.where(email: email_address).to_a[0]

    if @user
        if BCrypt::Password.new(@user[:password]) == password
            session["user_id"] = @user[:id]
            view "create_login"
        else
            view "create_login_failed"
        end
    else   
        view "create_login_failed"
    end
end

get "/logout" do
    session["user_id"] = nil
    view "logout"
end
