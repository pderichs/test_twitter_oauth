require 'sinatra'
require 'oauth'
require 'byebug'
require 'yaml'

exit if ARGV.size != 1

config = YAML.load_file(ARGV[0])

# Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
def prepare_access_token(config)
  consumer = OAuth::Consumer.new(
    config['consumer_key'],
    config['consumer_secret'],
    {
      :site => "https://api.twitter.com",
      scheme: :header
    }
  )

  # now create the access token object from passed values
  token_hash = {
    oauth_token: config['oauth_token'],
    oauth_token_secret: config['oauth_token_secret']
  }

  OAuth::AccessToken.from_hash(consumer, token_hash)
end

# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
access_token = prepare_access_token(config)

# use the access token as an agent to get the home timeline
response = access_token.request(
  :get,
  'https://api.twitter.com/1.1/statuses/home_timeline.json'
)

get '/twitter' do
  response.body
end
