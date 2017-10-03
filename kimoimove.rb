
class Sample
	def initialize
		@a = "a"
	end

	def a
		@a
	end

	def sampleMethod

		p a.class

		if false
			a = "kawatta"
		end

		p a().class
	end
end

Sample.new.sampleMethod



