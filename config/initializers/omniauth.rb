Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  provider :facebook, '135897973166254', '388fdb9286264568695465c6cb780192'
  #provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
