
class Klass

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


# クラスメソッドとは、クラスオブジェクトに定義された特異メソッド
# 特異クラスは、特異メソッドを定義した際、その特異メソッドが定義されるクラス

# ↓ つまり (俺はまだわかってないけど)

# クラスメソッドは、"クラスオブジェクトの特異クラス"に定義されていることになる


p klass = Klass.new      # #<Klass:0x007fb2e61ab918 @hoge=42>
p klass.class            # Klass
p Klass.class            # Class

p klass.singleton_class  # <Class:#<Klass:0x007f9ced88be90>>

p class << klass
	# これは、 klass.singleton_class で返る特異クラスオブジェクトと同じ
	self  # <Class:#<UNK:0x007ff6b506d048>>
end


p Klass.singleton_class  # クラスオブジェクトの特異クラス = 「メタクラス」。
# 特異クラスがメタクラス、というわけでなく、「クラスオブジェクトの特異クラス」がメタクラス。

# この self も同じ
p class << Klass
	self  # #<Class:Klass> クラスオブジェクトの特異クラス = 「メタクラス」
end

class Yonezu
end

yonezu = Yonezu.new
p yonezu.class

#######################

# 特異クラスとは「オブジェクトのクラスのサブクラス」を確かめてみる

str = "Hello!"

def str.count  # このdefで、strが参照しているオブジェクトの特異クラスが定義された
	self.size
end

# さっそく str の特異クラスを見てみよう
singleton = str.singleton_class    # <Class:#<String:0x007f864a21d1a8>>
p singleton.method_defined? :count # true

# では、Stringクラスのクラスメソッドを定義しよう

def String.maxim  # このdefで、String(が参照しているクラスオブジェクト)の特異クラスが定義された
	"Boys, be anbitious."
end

# さっそく String の特異クラスを見てみよう
p strSingleton = String.singleton_class  #<Class:String> メタクラスはこんなふうにprintされる
p strSingleton.method_defined? :maxim    # true

# 特異クラスとは「オブジェクトのクラスのサブクラス」の検証
p singleton.superclass     # String
p strSingleton.superclass  # #<Class:Object> ← これ変じゃね。ふつうに Class でええやん...なぜ





















