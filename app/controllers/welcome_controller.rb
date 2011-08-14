require 'digest/md5'
class WelcomeController < ApplicationController
    def index
    end
    
    def facebook_login
    end
    
    def view_owned_channels
        @user = User.where(:id => session["id"])[0]
        @channels = Channel.where(:owner_id => session["id"])
        @count = @channels.map &lambda {|x| ChannelUser.where(:channel_id => x.id).length}
    end
    
    def create_channel
    end
    
    def delete_channel
        channel_id = params[:channel_id]
        Channel.delete(channel_id)
        redirect_to :controller => 'welcome', :action => 'view_owned_channels'
    end
    
    def all_delete_channel
        channel_id = params[:channel_id]
        Channel.delete(channel_id)
        redirect_to :controller => 'welcome', :action => 'view_all_channels'
    end

    def call_create_api
        @channel_name = params[:channel_name]
        @website_url = params[:website_url]
        @moderate = params[:moderate]['true_false']
        @limit = params[:limit]['count']
        c = Channel.new(:owner_id => session["id"], :name => @channel_name)
        c.save
        redirect_to :action => 'view_owned_channels'
    end
    
    def create_user
    end
    
    def view_all_channels
        @channels = Channel.all
        count = @channels.map &lambda {|x| ChannelUser.where(:channel_id => x.id).length}
        count_hash = {} 
        for i in (0..(count.length-1))
            count_hash[i] = count[i]
        end
        @sorted_channels = count_hash.sort {|a,b| b[1] <=> a[1]}

    end
    
    def show_original_websites
    end
    
    def channel
    end
    
    def embeded_website
        @outside_link = params[:outside_link]
        if @outside_link
            if @outside_link.split("://")[1]
                @embeded_link = @outside_link
            else
                @embeded_link = "http://#{@outside_link}"
            end

            channel_identify = @embeded_link.dup
            channel_identify.gsub!("http://", "")
            
            @channel_id = Digest::MD5.hexdigest( channel_identify.gsub(/\?.*/ ,"").gsub(/\/$/,"") )[0,6]
            @channel_name = channel_identify
            
            render :layout => "outside"
        else
            redirect_to :action => 'index'
        end        
    end
    
    def learn_more
    end
end
