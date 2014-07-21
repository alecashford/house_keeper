class Expenditure < ActiveRecord::Base
	belongs_to :user
	belongs_to :utility
end
