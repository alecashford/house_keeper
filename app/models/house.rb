class House < ActiveRecord::Base
	has_many :users
	has_many :utilities

	def generate_code
	   random_characters = [(0..9).to_a, ('a'..'z').to_a].flatten
	   self.house_code = ""
	   5.times {self.house_code += random_characters.sample.to_s}
	   self.save
	   return self
  end
end