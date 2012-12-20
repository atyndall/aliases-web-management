require 'aliases/aliases'

get "/" do
  @aliases = Aliases.new()
  haml :index
end

