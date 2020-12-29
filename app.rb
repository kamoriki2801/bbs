require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './models/contribution.rb'
require './models.rb'
require 'pry'

enable :sessions

before do
  Dotenv.load
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUD_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
  end
  ＠current_user = session[:user]
end

get '/' do
  @contents = Contribution.all.order('id desc')
  erb :index
end

post '/new' do
  img_url = ''
  if params[:file]
    img = params[:file]
    tempfile = img[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
  end
  Contribution.create({
    name: params[:user_name],
    body: params[:body],
    tag: params[:tag],
    good: 0,
    img: img_url
  })

  redirect '/'
end

post '/good/:id' do
  content = Contribution.find(params[:id])
  good = content.good
  content.update({
    good: good + 1
  })
  redirect '/'
end

post '/delete/:id' do
  Contribution.find(params[:id]).destroy
  redirect '/'
end

get '/edit/:id' do
  @content = Contribution.find(params[:id])
  erb :edit
end

post '/renew/:id' do
  content = Contribution.find(params[:id])
  content.update({
    name: params[:user_name],
    body: params[:body]
  })
  redirect '/'
end

post '/tag/:tag' do
  @contents = Contribution.where(tag: params[:tag]).order('id desc')
  erb :index
end

get '/signin' do
  erb :sign_in
end

get '/signup' do
  erb :sign_up
end

post '/signin' do
  user = User.find_by(mail:params[:mail])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
    puts "Hell"
  end
  redirect '/'
end

post '/signup' do
  @user = User.create(mail:params[:mail], password:params[:password],
  password_confirmation:params[:password_confirmation])
  if @user.persisted?
    session[:user] = @user.id
  end
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end