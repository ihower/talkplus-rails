require 'json'
class SessionsController < ApplicationController
  def create
    user_profile = request.env['omniauth.auth'].inspect
    #jj = JSON.parse(user_profile)
    #render :text => user_profile["uid"]
    hash_user_profile = eval(user_profile)
    existed = User.where(:uid => hash_user_profile["uid"])[0]

    if existed
        session["id"] = existed.id
    else
        u = User.new()
        u.update_attributes(:name => hash_user_profile["user_info"]["name"], \
                            :email => hash_user_profile["user_info"]["email"], \
                            :uid => hash_user_profile["uid"])
        session["id"] = u.id
    end
    session["fb_token"] = hash_user_profile["credentials"]["token"]
    #render :text => hash_user_profile
    redirect_to :controller => 'welcome', :action => 'view_owned_channels'
    #render :text => request.env['rack.auth'].inspect
  end
end
