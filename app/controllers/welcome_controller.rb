class WelcomeController < ApplicationController
    def index
    end
    
    def facebook_login
    end
    
    def view_owned_channels
    end
    
    def create_channel
    end
    
    def call_create_api
        @channel_name = params[:channel_name]
        @website_url = params[:website_url]
        @moderate = params[:moderate]['true_false']
        @limit = params[:limit]['count']
    end
    
    def create_user
    end
    
    def view_all_channels
    end
    
    def show_original_websites
    end
    
    def channel
    end
    
    def learn_more
    end
end
