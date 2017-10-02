
eval "1+1"  # 2

# P.553  Bindingオブジェクト


# これらはnilになるが...
# p eval "@instance_val"
# p eval "local_val"
# p eval "private_method"

class EvalTarget
	def initialize
		@instance_val = "instance_val"
	end

	def instance_binding
		local_val = "local_val"
		binding
	end

	private
	def private_method
		"private_method"
	end
end

e1 = EvalTarget.new
binding_object = e1.instance_binding

# しかし、Bindingオブジェクトを渡すと、OK
eval "@instance_val",  binding_object
eval "local_val",      binding_object
eval "private_method", binding_object

# これでも同じこと
binding_object.eval "@instance_val"
binding_object.eval "local_val"
binding_object.eval "private_method"

# class_eval, module_eval

class EvalTarget2
	@class_class_instance = 10
	class << self
		def class_class_instance
			@class_class_instance
		end
	end
end

EvalTarget2.class_class_instance

val = 1
EvalTarget2.class_eval do |variable|
	# p variable  # ブロックの変数 = クラスオブジェクトとなる。 EvalTarget2.
	# p self	  # selfも同じく、  クラスオブジェクトとなる。 EvalTarget2.
	@class_class_instance = 20

	#このように、クロージャとして外側の変数を参照し、値を設定することが可能。
	# ↑ の例も ↓ の例も、「インスタンス変数」ではなく、「クラスインスタンス変数」を設定している点に気づけ。
	@dynamic_class_instance = val	
end

EvalTarget2.instance_variable_get :@class_class_instance
EvalTarget2.instance_variable_get :@dynamic_class_instance


# instance_eval

class EvalTarget3
	attr_accessor :instance_val

	def initialize
		@instance_val = 0
	end

	private
	def private_method
		@instance_val = 100
	end
end

e1 = EvalTarget3.new
e1.instance_val

e1.instance_eval do |variable|
	# このブロック内のスコープ = インスタンス なので、このようにインスタンス変数の設定が可能。
	# @instance_val = 42

	# setterがあるならもちろんこれでもOK. self.xxxでももちろんOK. attr_readerだと動かない、ってことね。	
	variable.instance_val = 42
end

e1.instance_val

e1.instance_eval do
	# スコープ上、プライベートメソッドが呼べてしまうのも利点
	private_method
end

e1.instance_val


# スコープの違いが関数定義場所の違いを生む

class Eval
end

t1 = Eval.new
t2 = Eval.new

# class_eval 内で def すると、
# インスタンスメソッド定義となる
# (落ち着け。よく見るとふつうの class定義内にdefを書いてるのと同じ、だと気づくはず。)
Eval.class_eval {
	def insance_method
		:instance_method
	end
}

# うわー、めっちゃ動的って感じしますわ。
t1.insance_method  # :instance_method
t2.insance_method  # :instance_method

t1.instance_eval {
	def unique_method
		:unique_method
	end
}

# t1.unique_method  # :unique_method

# もちろんこっちは NoMethodError.
# t2.unique_method


# 最後

# class LastEval
# 	CONST_VAL = "LastEval::CONST_VAL"
# 	attr_accessor :instance_val
# end

# CONST_VAL = "CONST"

# t3 = LastEval.new

# # evalのブロック内で CONST_VAL を参照しても、LastEval::CONST_VALが参照されてしまう
# t3.instance_eval {
# 	@instance_val = CONST_VAL
# }

# p t3.instance_val  # CONST


class EvalTarget
  CONST_VAL = "EvalTarget::CONST"
  attr_accessor :instance_val
end

CONST_VAL = "CONST"

e11 = EvalTarget.new

# evalのブロック内でCONST_VALを参照してもEvalTarget::CONST_VALが参照されてしまう
e11.instance_eval { @instance_val = CONST_VAL }
p e11.instance_val  # CONST おかしい！！！！！！！！！！！！！！！！！！

# CONST_VALをinstance_execの引数で渡すと、このコンテキストのCONST_VALを渡せる
e11.instance_exec(CONST_VAL) {|const_val| @instance_val = const_val }
p e11.instance_val #=> "CONST”



















