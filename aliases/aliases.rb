require 'aliases/alias'
require 'aliases/validation_error'

class Aliases
  def initialize
    @aliases = []

    # Construct from /etc/aliases
    afile = File.open('/etc/aliases', 'rb')
    aliases_contents = afile.read
    afile.close

    parse(aliases_contents)
  end

  private
  def parse(aliases_contents)
    # We only pay attention to stuff between matching sets of '#%%%'
    # Piping statement lines will be ignored, comments will be ignored
    lines = aliases_contents.split("\n")

    aliases = {}
    emails = {}
    parse = false

    lines.each do |line|
      line.strip!
      if parse
        if line[0] == '#'
          next
        elsif m = /^\s*([a-z0-9]+)\s*:\s*([^|]+)\s*$/i.match(line)
          a = m[1]
          dest = m[2].split(',')

          if not aliases.has_key? a
            aliases[a] = Alias.new(a)
          end

          dest.each do |d|
            d.strip!
            if d =~ /@/
              if not emails.has_key? d
                emails[d] = EmailDestination.new(d)
              end
              aliases[a].add_destination(emails[d])
            else
              if not aliases.has_key? d
                aliases[d] = Alias.new(d)
              end
              aliases[a].add_destination(aliases[d])
            end

          end
        end
      elsif line =~ /^#%%%/
        parse = !parse
      end
    end

    aliases.each do |k, v|
      @aliases << v
    end
  end

  public
  def format
    str = ''
    @aliases.each do |v|
      str << v.name
      str << ':'
      str << v.destinations.join(',')
      str << "\n"
    end
    str
  end

  public
  def each(&blk)
    @aliases.sort! { |a, b| a.name.downcase <=> b.name.downcase }
    @aliases.each(&blk)
  end
end