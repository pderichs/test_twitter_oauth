require 'sinatra'
require 'oauth'
require 'yaml'
require 'uri'

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
    oauth_token: config['access_token'],
    oauth_token_secret: config['access_token_secret']
  }

  OAuth::AccessToken.from_hash(consumer, token_hash)
end

# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
access_token = prepare_access_token(config)

# use the access token as an agent to get the home timeline

get '/' do
  content_type :html
  File.read('client/index.html')
end

get '/twitter' do
  # content_type :json
  url = URI.escape(params['url'])
  complete_url = "https://api.twitter.com/1.1/#{url}"
  puts "Querying url: #{complete_url}"
  response = access_token.request(
    :get,
    complete_url
  )
  response.body
end
