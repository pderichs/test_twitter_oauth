# Inspired by https://dev.twitter.com/oauth/overview/single-user

require 'sinatra'
require 'oauth'
require 'yaml'
require 'uri'

exit if ARGV.size != 1

config = YAML.load_file(ARGV[0])

def twitter_consumer_by(config)
  OAuth::Consumer.new(
    config['consumer_key'],
    config['consumer_secret'],
    site: 'https://api.twitter.com',
    scheme: :header
  )
end

def token_hash_by(config)
  {
    oauth_token: config['access_token'],
    oauth_token_secret: config['access_token_secret']
  }
end

def prepare_access_token(config)
  consumer = twitter_consumer_by(config)
  token_hash = token_hash_by(config)
  OAuth::AccessToken.from_hash(consumer, token_hash)
end

# now create the access token object from passed values
access_token = prepare_access_token(config)

get '/' do
  File.read('client/index.html')
end

get '/js/test.js' do
  File.read('client/js/test.js')
end

get '/twitter' do
  url = URI.escape(params['url'])
  complete_url = "https://api.twitter.com/1.1/#{url}"
  puts "Querying url: #{complete_url}"
  response = access_token.request(
    :get,
    complete_url
  )
  response.body
end
