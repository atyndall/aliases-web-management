require 'rubygems'

require 'bundler'
Bundler.require(:default)

require 'sinatra'
require 'haml'
require 'sass/plugin/rack'

require './app'

set :run, false
set :raise_errors, true
set :haml, :format => :html5

# use scss for stylesheets
Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

# use coffeescript for javascript
use Rack::Coffee, root: 'public', urls: '/javascripts'

run Sinatra::Application
