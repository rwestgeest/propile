class ReduceFieldSessionLaptopsRequired < ActiveRecord::Migration
  class Session < ActiveRecord::Base
    attr_accessible :laptops_required
  end
  def up
    Session.all.each do |session|
      reduced_laptops_required = (!session.laptops_required.nil? and !session.laptops_required.empty? and !session.laptops_required.upcase.include?("NO")) ?  "yes" : "no"
      session.update_attribute :laptops_required, reduced_laptops_required
    end 
  end

  def down
    #not possible, not important
  end
end
