require 'digest/md5'
class WelcomeController < ApplicationController
    def index
        @channels = Channel.all
        # brute force. that name is too long. take it away
        too_long = Channel.where("name like '%taipei.startupweekend.org/2011/08/16/%'")
#        render :text => @channels - too_long

        @channels = @channels - too_long
        count = @channels.map &lambda {|x| ChannelUser.where(:channel_id => x.id).length}
        count_hash = {} 
        for i in (0..(count.length-1))
            count_hash[i] = count[i]
        end
        @sorted_channels = count_hash.sort {|a,b| b[1] <=> a[1]}
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
            channel_identify = channel_identify.gsub("https://", "").gsub("http://", "").gsub(/\?.*/ ,"").gsub(/\/$/,"")
            
            channel = Channel.find_by_uid( channel_identify )
            
            unless channel            
              channel = Channel.new( :name => channel_identify, :uid => channel_identify )
              channel.save
            end
              
            @channel_id = channel.id
            @channel_name = channel.name
            @page_title = channel.name
            render :layout => "outside"
        else
            redirect_to :action => 'index'
        end        
    end
    
    def learn_more
    end
end
