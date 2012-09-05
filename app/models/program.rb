class Program < ActiveRecord::Base
  attr_accessible :version
  has_many :program_entries

end
