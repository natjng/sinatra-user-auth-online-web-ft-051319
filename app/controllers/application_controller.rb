class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do

    erb :'/registrations/signup'
  end

  post '/registrations' do
    puts params
    # will show params from form in terminal

    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    # use data in params to create a new user

    session[:user_id] = @user.id
    # log in new user by setting user id it to the session[:user_id]
    
    redirect '/users/home'
  end

  get '/sessions/login' do

    # the line of code below render the view page in app/views/sessions/login.erb
    erb :'sessions/login'
  end

  post '/sessions' do
    puts params

    @user = User.find_by(email: params[:email], password: params[:password])
    # find user with email and password data from params

    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
      # if user is found in db, log in user by setting user id to session[:user_id] and redirect use to get '/users/home' route
    end
    redirect '/sessions/login'
  end

  get '/sessions/logout' do
    session.clear
    redirect '/'
    # log out user by clearing data in session hash and redirect to home page
  end

  get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home'
    # find current user using :user_id in session hash and set to instance variable so user data may be rendered in view file (/users/home)
  end
end
