class ChannelsController < ApplicationController
  
  def js
    @channel = Channel.find( params[:id] || 1 )
    render :layout => false
  end
  
  def recent
    @channels = Channel.order("id desc")
    
    respond_to do |format|
      format.json { render :json => @channels.to_json }
    end    
  end
  
  def popular
    @channels = Channel.all # TODO
    
    respond_to do |format|
      format.json { render :json => @channels.to_json }
    end    
  end
  
  def nearby
    @channels = Channel.all # TODO
    
    respond_to do |format|
      format.json { render :json => @channels.to_json }
    end    
  end
  
  def show
    @channel = Channel.find_by_uid( params[:id] )
    
    respond_to do |format|
      format.json { render :json => @channel.to_json }
    end
    
  end
  
end