
class SessionsController < ApplicationController
  def create
    user_profile = request.env['omniauth.auth'].inspect
    
    #render :text => request.env['omniauth.auth'].inspect
    redirect_to :controller => 'welcome', :action => 'view_owned_channels'
    #render :text => request.env['rack.auth'].inspect
  end
end
