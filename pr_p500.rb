
# メソッド探索

# 1 自身のメソッド呼び出し

class BaseClass
	def hello
		:hello
	end
end

baseObj = BaseClass.new
p baseObj.hello


# 2 スーパークラスのメソッド呼び出し

class InheritClass < BaseClass
end

inheritObj = InheritClass.new
p inheritObj.hello


# 3 特異メソッドの呼び出し

def baseObj.hello
	:singleton_method_hello
end

p baseObj.hello


# 4 mix-inしたメソッド呼び出し

module HelloModule
	def hello_from_module
		:hello_from_module
	end
end

# 既に定義したクラスをもう一回、てか何度でも、再定義できる。
# 既に親クラスとして取り込まれている < BaseClass もいちいちもう一度書かなくて良い模様
class InheritClass
	include HelloModule  # 既存の InheritClassに 追加でモジュールInclude
end

inheritObj.hello_from_module


# 5
# inheritObj.not_exist_method  # NoMethodError






















