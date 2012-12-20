require 'rubygems'

require 'bundler'
Bundler.require(:default)

require 'sinatra'
require 'sinatra/config_file'
config_file File.dirname(__FILE__) + '/config/config.yml'

require 'haml'
require 'sass/plugin/rack'

$:.unshift File.dirname(__FILE__) # Add current dir to load path

require 'app'

set :run, false
set :raise_errors, true
set :haml, :format => :html5

# use scss for stylesheets
Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

# use coffeescript for javascript
use Rack::Coffee, root: 'public', urls: '/javascripts'

run Sinatra::Application
