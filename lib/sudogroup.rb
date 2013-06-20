
class SudoGroup
  
  attr_reader   :name
  attr_reader   :alias_type
  attr_accessor :items
  
  def initialize(name)
    @name = name
    @alias_type = 'Unknown'
    @items = []
  end
  
  
  def to_s
    "%-15s %s = %s\n" % [alias_type, name, items.join(',')]
  end
  
  # Compare this object to another object and return if they are equivilent
  # Params:
  # +other+:: SudoGroup instance to compare to 
  def ==(other)
    if name == other.name and alias_type == other.alias_type and items == other.items
      return true
    else
      return false
    end
  end
  
end
