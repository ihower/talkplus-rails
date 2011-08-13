module WelcomeHelper
    def user_photo(uid)
        return raw("<img src='http://graph.facebook.com/#{uid}/picture' />")
    end
    def user_large_photo(uid)
        return raw("<img src = 'http://graph.facebook.com/#{uid}/picture?type=large' width='148'>")
    end
end

