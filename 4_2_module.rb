
module Greetable
	def greet_to(name)
		puts "Hello, #{name}. My name is #{(p self.class)}."
	end
end

class Alice
	include Greetable

	def greet_to(name)
		super  # ここ、super()とすると、エラーになる。理由はわかるな...?
		puts "Nice to meet you."
	end
end

Alice.new.greet_to "Bob"

######

# main について

# これは Objectクラスへのクラスメソッド定義とはならない。なんでか?
# 多分だが、トップレベルのselfは mainオブジェクトを返し、Objectクラスオブジェクトを返すわけではない。
# (main とは、"オブジェクト" です)
# そのためこれはクラスメソッド定義とみなされない。mainオブジェクトへの特異メソッド定義となる。

# def self.unko
# 	:trueunko 
# end
# p self.unko  # trueunko

# # まぁ、そうとわかれば、こうすりゃいいわな
# def (self.singleton_class.superclass).unko  # ()で囲まないとダメ
# 	:unko
# end
# p Object.unko

# てか、「インスタンスから親クラス取得する」の、ここまでしなくちゃいけないのか? 地味にめんどい...めんどいよね..?
# インスタンスは superclassメソッドを持っていないから


## モジュールの特異メソッド / 特異クラス

# 論理的に考えると、moduleも特異メソッドを持てる。まぁつまり "moduleのクラスメソッド"ってことであるな
module MyModule
end

def MyModule.cool
	:cool!
end

p MyModule.cool  # :cool!

p MyModule.singleton_class  # #<Class:MyModule> メタクラス
p MyModule.singleton_class.method_defined? :cool  # true


# self.extend Math
# sqrt(4)











