class User < ActiveRecord::Base
	belongs_to :house
	has_many :expenditures
	has_many :utilities, :through => :expenditures
end
