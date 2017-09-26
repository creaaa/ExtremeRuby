
# id_proc = Proc.new{ |a| a }
# p id_proc.call(42)

# # Proc.newにブロックを渡さなかったときは、関数定義に渡されたブロックでProcオブジェクトを作成
# # それすらも渡ってこなければ、ArgumentError
# def proc_factory
# 	Proc.new  # ブロックがなかった場合、Proc.new がエラーを投げる
# end

# proc = proc_factory {|a| a}

# # Procコールはこのとおり

# p proc.call 42
# p proc[42]
# p proc.(42)

# sum_proc = Proc.new {|x,y| x + y}
# p sum_proc === [1,2]

#####

# def what_class(obj)
# 	case obj							 # 2. 引数 
# 	when proc { |x| x.kind_of? String }  # 1. レシーバ
# 		String
# 	end
# end

# whenのマッチングは === で行われる。
# Procオブジェクトの === は、"Procの実行" という意味でオーバーライドされている。
# caseのオブジェクトを引数にProcを実行
# この場合は、引数にStringオブジェクトを渡していたら、Proc実行の結果、trueを返す
	# → このwhen節にマッチ → Stringクラスオブジェクトが返る

# p what_class("32")

# Kernel#proc
# proc_obj = proc {1}
# p proc_obj.call

#####

# def convert_proc #(&block) ← これはなくてよい。暗黙的にブロック取れる(Procオブジェクトは取れない)
# 	# yield は、Procオブジェクトにしか実行できない。
#   たぶんだが、暗黙のブロックを実行しているように見えたら、たぶん、メソッドの引数の (&block) が省略されている、ていうのが正しいはず
# 	# てか yieldが可変長の引数取れるんだが、この意味は何.....
# 	# (しかもそれは実行に何の影響を及ばさず、あくまで引数で取ったProcを実行、という挙動になる)
# 	yield 34, 44
# end

# proc_obj = convert_proc{42}
# p proc_obj

#####

# def yield_proc
# 	# yieldは「Procオブジェクトしか実行できない」(ブロックはできない)はずだが、できてるのはなぜ??
# 	# 	→ メソッド定義の引数定義で (&block) が省略されているから。
# 	# つまりここでは、 procオブジェクトに&をつけてブロックとして渡す → 暗黙の(&block)が発動し再度Procオブジェクトに変換、
# 	# という、冷静に見ればアホなことやってる。
# 	# なぜこうまでしたいかといえば、暗黙のうち(&block) に引数として渡せるのはブロックだけで、
# 	# Procオブジェクトを渡したいなら、引数として書かないとダメだからだ....。
# 	yield
# end

# proc_obj = Proc.new {1}
# yield_proc &proc_obj

##### 

# 8-2 Lambda

# ラムダ化1
# lambda_obj = lambda {1}  # .classすると、Procと出る。ただしもちろん内部的にはLambda
# p lambda_obj.call

# # ラムダ化2
# inc = -> (x) {x+1}
# p inc.(42)


#####

# 8-3 Proc vs Lambda

# 【returnの挙動】

# Proc:    メソッドを抜ける(=トップレベルで実行されるとlocalJumpError)
# Lambda:  制御(クロージャのブロックのみ)を抜ける

# [case 1: Procの場合]

# メソッド内に Procがあり、その中でreturnされる場合は、エラーにならないが...
# def proc_return
# 	# クロージャのブロックを抜け(だから puts :unreach...は実行されない)、さらにメソッド全体を抜けるので...
# 	Proc.new { return 1; puts :unreachable }.call
# 	:unreachable　# Lambdaの場合と違い、ここが実行されない
# end

# p proc_return  # 1

# トップレベルにProcがあり、その中でreturnするとlocalJumpErrorに
# Proc.new{ return 1; puts :unreachable}.call  # localJumpError

# とりま、Procは「トップレベルでreturnするとエラー」とおぼえよう


# [case 2: Lambdaの場合]

# def lambda_return
# 	lambda { return 1; puts :unreachable }.call # クロージャのブロックだけを抜け、メソッド自体はぬけないので...
# 	:reachable  # Procの場合と違い、ここが実行される
# end

# p lambda_return  # :reachable

# # トップレベルで書いてもエラーにならない(普通のメソッドと同じ挙動になる)
# p lambda { return 1; puts :unreachable }.call  # 1

# 【breakの挙動】

# [case 1: Procの場合]

# def proc_break
# 	Proc.new{ break 1; puts :unreachable }.call
# end

#  proc × breakの場合は、メソッドの場合と違い、問答無用でエラー
# proc_break.call  # break from proc-closure (LocalJumpError)

# これはもちろん論外
# Proc.new{ break 1; puts :unreachable }.call  # break from proc-closure (LocalJumpError)


# [case 2: Lambdaの場合]

# Lambdaの場合は、return と break の挙動は全く同じなので覚えやすい

# def lambda_break
# 	lambda{ break 1; puts :unreachable }.call
# 	:reachable
# end

# p lambda_break  # :reachable

# # トップレベルで書いたときの挙動も returnの場合と全く同じ
# p lambda{ break 1; puts :unreachable }.call  # 1


# 【引数の挙動】

# Procの場合は、引数の数が違っても動く
# Lambdaの場合は、引数の数が違うとエラー

# proc   { |x,y| x }.call(1)  # 1
# lambda { |x,y| x }.call(1)  # wrong number of arguments (given 1, expected 2) (ArgumentError)


# このおっかなそうなProcの挙動について細かく

# ・仮引数の数より多く引数が渡された場合は、その引数を無視する
# ・引き数の数が足りない場合、足りない引数にはnilが渡される
# ・複数の仮引数が定義されている時に配列が1つだけ渡されると展開される

# args_proc = proc {|x,y| [x,y]}

# p args_proc[1,2,3]  # [1,2]
# p args_proc[1]      # [1,nil]
# p args_proc[[1,2]]  # [1,2] これはちょっとわかりにくい...

# "複数の仮引数が定義されている時に配列が1つだけ渡されると展開される"というルールだけは、
# lambdaでも有効っぽい。

# args_lambda = lambda {|x,y| [x,y]}
# p args_lambda[1,2]  # [1,2]

# Proc製の Procオブジェクトか、 Lambda製のProcオブジェクトか(ややこしいな)は、
# Proc#lambda? で判断できる

# p proc {}.lambda?    # false
# p lambda {}.lambda?  # true

# ただし！！ Method#to_proc で生成した Procオブジェクトは、
# lambda? でtrueを返す (これくそ厄介な挙動じゃね。。。)


# languages = %w(Perl Python Ruby PHP JavaScript)

# u = languages.each { |language|
# 	puts language
# 	if language == "Ruby"
# 		puts "I found Ruby"
# 		#break "unko"
# 	end
# }















