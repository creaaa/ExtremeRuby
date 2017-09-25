class Hello

	@@unk = 42

	def hoge
		p @@unk
	end

	def self.fuga
		p :fuga
	end
end


class Ikinari
	# クラス定義内のselfを出力すると、こうなる
	# p self          # Ikinari
	# p self.class    # Class
end

# 一方、トップレベルのselfの出力は、こう
p self		        # main    ふつうだと Objectと出るはずだが...
p self.class        # Object  ここでObjectになる。
p self.class.class  # Class


# prepend の優先順位

module Un1
	def un
		:un1
	end
end

module Un2
	def un
		:un2
	end
end

module Un3
	def un
		:un3
	end
end

class UnUnUn
	prepend Un3
	prepend Un2
	include Un1
end

ununun = UnUnUn.new
p ununun.un


module Included
	def inc
		:inc_from_module
	end
end

class Owner
	include Included
	def inc
		:inc_from_class
	end
end

owner = Owner.new
p owner.inc  # :inc_from_class
















