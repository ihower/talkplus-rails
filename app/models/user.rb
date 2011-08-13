class User < ActiveRecord::Base
    def self.create_from_hash!(hash)
        create(:name => hash['user_info']['name'])
    end
end
