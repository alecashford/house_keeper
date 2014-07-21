class Utility < ActiveRecord::Base
	belongs_to :house
	has_many :users, :through => :expenditures
end
