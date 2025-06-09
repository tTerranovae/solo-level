class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(provider: auth['provider'], uid: auth['uid']) do |u|
      u.email = auth['info']['email']
      u.name = auth['info']['name'] || auth['info']['nickname']
    end
    session[:user_id] = user.id
    redirect_to root_path, notice: 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out!'
  end

  def failure
    redirect_to root_path, alert: 'Authentication failed.'
  end
end 