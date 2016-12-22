require 'bundler/setup'
require 'sinatra'
require 'bcrypt'
Bundler.require(:default)
enable :sessions
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

def login
  @user = User.find_by_email(params[:username])
  if @user.password == params[:password]
    session[:id] = @user.id
  else
    redirect_to '/sign_in'
  end
end

get '/' do
  erb :index
end

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  user = params[:user]
  email = params[:email]
  if User.exists?(email: email)
    binding.pry
    @email_error = true
    erb :sign_up
  elsif params[:password1] != params[:password2]
    @password_error = true
    erb :sign_up
  else
    @user = User.new({user_name: user, email: email})
    @user.password = params[:password]
    @user.save!
    session[:id] = @user.id
    redirect to '/users/home'
  end
end

get '/users/home' do
  @user = User.find(session[:id])
  erb :home
end

get '/sign_in' do
  erb :sign_in
end

post '/sign_in' do
  login
  erb :home
end

get '/logout' do
  session.clear
  @logout = true
  erb :sign_in
end

get '/teams/new' do
  erb :team_create
end

post '/teams/:id' do
  name = params[:team_name]
  logo = params[:logo_url]
  bio = params[:team_bio]
  Team.create({name: name, team_info: bio, logo: logo})
  redirect '/team/:id'
end

get '/teams' do
  @teams = Team.all()
  @user = User.find(session[:id])
  erb :teams
end

# get '/teams/:id' do
#
# end
#
# patch 'teams/:id' do
#
# end
#
# delete 'teams/:id' do
#
# end
