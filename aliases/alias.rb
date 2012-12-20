require 'aliases/destination'
require 'aliases/email_destination'

class Alias < Destination
  attr_reader :destinations

  def initialize(alias_name)
    if alias_name =~ /^[0-9A-Z]+$/i
      @name = alias_name.to_s
    elsif
      raise ValidationError, "Alias '#{alias_name}' is not alphanumeric"
    end

    @destinations = []
  end

  def add_destination(dobj)
    if dobj.class < Destination
      if not @destinations.include? dobj and dobj.name != self.name
        @destinations << dobj
      end
    elsif
      raise ValidationError, "Passed an object that isn't a Destination"
    end
  end
end