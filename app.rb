require 'aliases/aliases'

get "/" do
  @aliases = Aliases.new(settings.aliases_location)
  @domain = "@#{settings.aliases_domain}"
  haml :index
end

