require 'aliases/aliases'

set :aliases_object, Aliases.new(settings.aliases_location)

get '/' do
  settings.aliases_object = Aliases.new(settings.aliases_location)
  @aliases = settings.aliases_object
  @domain = "@#{settings.aliases_domain}"
  haml :index
end

get '/aliases.json' do
  content_type :json
  @aliases = settings.aliases_object
  @aliases.to_json
end

post '/aliases.json' do

end