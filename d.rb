
class HH

	# @@fuga = 33

	def initialize
		@hoge = 42
		@@fuga = 100
	end

	unko = 1

	def getHoge
		self
	end

	def self.globalHoge
		self
	end

end


p HH.singleton_class.superclass




