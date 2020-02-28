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
    view "venues"
end

get "/venues/:id" do
    @venue = venues_table.where(id: params[:id]).first
    view "venue"
end

get "/venues/:id/reviews/new" do
    @venue = venues_table.where(id: params[:id]).first
    view "new_review"
end

get "/venues/:id/reviews/confirm" do
    @venue = venues_table.where(id: params[:id]).first
    view "reviews_confirm"
end

get "/venues/new" do
    view "new_venue"
end

get "/venues/confirm" do
    view "venue_confirm"
end
