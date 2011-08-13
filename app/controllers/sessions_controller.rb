
class SessionsController < ApplicationController
  def create
    user_profile = request.env['omniauth.auth'].inspect
    
    render :text => request.env['omniauth.auth'].inspect
    #render :text => request.env['rack.auth'].inspect
  end
end
