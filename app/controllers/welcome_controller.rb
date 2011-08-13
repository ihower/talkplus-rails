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
    
    def learn_more
    end
end
