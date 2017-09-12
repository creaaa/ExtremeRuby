
# # 関数(def)を変数に格納する、という概念はRubyにはない??

# =begin 
# def unko
#   # 何も書かない場合、戻り値は NilClassになる
# end

# func = unko       # 変数に関数を格納する、という概念はないように思われる。
#           # なぜなら、この場合、関数の代入ではなく、関数の実行(そしてその戻り値を変数に代入)という挙動なので。
#           # 関数を変数を格納するならば、proc にするしかない、と思われる。
# print func.class  # NilClass
# =end

# # 【重要】

# # Pythonがサポートしている無名関数はラムダ式のみですが、
# # Rubyはブロック、Procオブジェクト、ラムダ式といった種類の無名関数があります。


# # 【基本】ブロック付メソッド呼び出し

# # pattern 1
# # [1,2,3].each do |i| print i*2, "\n" end
# # pattern 2 (結果は1と同じ)
# # [1,2,3].each {|i| print i*2, "\n" }

# # do end と {} の違い → {}のほうが結合が強い。
# # ただ、これに依存するコードは書いてはいけない。
# # 参考: http://mickey24.hatenablog.com/entry/20100914/1284475769

# # Rubyのfor文は、実は内部的にはeachメソッドを使用している



# # 手続きオブジェクト(Proc) (多言語のクロージャ、'変数に入った関数')

# # proc = 「ブロックをオブジェクト化したもの」

# =begin 

# myProc = proc { |v|
# 	p v
# }

# [1,2,3].each(&myProc)  # 1 2 3

# # つまり、each() は、「'1つの引数を取るブロック'を1つ引数に取るメソッド」。
# # ...とも限らなかった。こんなこともできた

# # 例)hash
# sum = 0
# outcome = {'join' => 1000, "shopping" => 1000, 'food' => 4000}
# outcome.each do |item, price|
#   sum += price
# end
# puts sum  # => 6000

# =end

# # 違う例でもっと練習しよう。

# # & = 「ブロックをprocに変換するよ」、という意味
# def block(&the_block)
# 	the_block  # ブロックが返る
# end

# adder = block { |a, b| a + b }
# p adder.class  # proc  (ブロックを格納する変数の型は、 Proc になる)

# # これを使うには、Procオブジェクトが持つcall()メソッドを使う
# p(adder.call(42, 1))

# # proc と lambda は、基本コンセプトは同じなので安心していいが、細かい挙動が異なる。



# =begin 

# # 引数に & をつけると、ブロックを受け取ります。元々は繰り返し処理のために実装されたため、ブロックはイテレータとも呼ばれます。

# def hello(cnt, &block_arg)
#   cnt.times do
#     block_arg.call
#   end
# end

# #hello(3) { print "Hello " }       #=> Hello Hello Hello

# =end


# # yield

# # 「ブロックを呼び出す物」
# # yieldは、イテレータを定義するために、クラス／メソッド定義 で使用する

# #
# # case 1
# #

# # ブロック付きメソッドの定義、
# # その働きは与えられたブロック(手続き)に引数1, 2を渡して実行すること
# def foo
#   yield(1,2)
# end

# # fooに「2引数手続き、その働きは引数を配列に括ってpで印字する」というものを渡して実行させる
# foo { |a, b|
#   p [a, b]
# }  # => [1, 2] (要するに p [1, 2] を実行した)

# # 今度は「2引数手続き、その働きは足し算をしてpで印字する」というものを渡して実行させる
# foo {|a, b|
#   p a + b
# }  # => 3 (要するに p 1 + 2 を実行した)

# # 
# # case 2
# # 

# # 今度のブロック付きメソッドの働きは、
# # 与えられたブロックに引数10を渡して起動し、続けざまに引数20を渡して起動し、
# # さらに引数30を渡して起動すること
# def bar
#   yield 10
#   yield 20
#   yield 30
# end

# # barに「1引数手続き、その働きは引数に3を足してpで印字する」というものを渡して実行させる
# bar {|v|
#   p v + 3
# }
# # => 13
# #    23
# #    33 (同じブロックが3つのyieldで3回起動された。
# #        具体的には p 10 + 3; p 20 + 3; p 30 + 3 を実行した)

############################################################

# http://qiita.com/kidach1/items/15cfee9ec66804c3afd2
# Ruby block/proc/lambdaの使いどころ


# ブロック: do~end（もしくは{~}）で囲われた、引数となるためのカタマリ

# yieldは「ブロックを呼び出すもの」、
# Procは「ブロックをオブジェクト化したもの」であり、
# ブロック自体とは別物、って点が超重要


# それ単体では存在できず、メソッドの引数にしかなれない
#    「do~endのカタマリ」がその辺に単体で転がっているのは見た事ないはず。
# 引数として渡されたブロックは、yieldによって実行される


#ブロックを受け取るメソッドの定義
# def give_me_block
#   yield()
# end

#メソッドの引数としてブロック（do~end）を渡して、実行
# give_me_block do
#   p "Hello, block!"   # "Hello, block!"    #give_me_block内で、yieldによって呼び出された。
# end


# yieldをわからせるためにステップ・バイ・ステップで行く

# Lv.1. 「そもそもブロックとは引数であること」を明示した書き方も存在する

# メソッド定義
# ( &block )で、ブロック引数を受け取ることを明示している
def give_me_block( &block )
  block.call
end

# 実行
give_me_block do
  p "Hello, block!"  # => "Hello, block!"
end


# &blockの「&」って？

#&を付けることで、実際に引数にブロックが渡ってきた際、Procオブジェクトに変換している

# Procオブジェクトって？

# Proc = ブロックをオブジェクト化したもの
# ブロックがそれ単体では存在できないことを思い出す （→オブジェクト化してしまえばok）
# ブロックをオブジェクトに変換することで、引き渡されたメソッド（give_me_block）内で扱えるようにする
# Procオブジェクトは、callで呼び出すことが出来る
# block.callの正体はこれ

# ちなみに、ブロック引数は、仮引数の中で一番最後に定義されていなければならない

# NG
# def give_me_block( &block1, param1 )
# def give_me_block( &block1, &block2 )
# つまるところ引数として渡せるブロックは一つだけ。


# Lv.2 
# 「どうせブロック引数は一つしか取れないんだから、
#  block.callなんて明示せずに、yieldで統一しちゃえば良いじゃん」

# メソッド定義
def give_me_block( &block )
  yield    # block.callをやめてyieldに変更
end

# 実行
give_me_block do
  p "Hello, block!"  # => "Hello, block!"
end


# Lv.3 「ブロックは全部yieldが示すんだから、仮引数（&block）もいらなくね？」

#メソッド定義
def give_me_block  # (&block)を除去
  yield
end

#実行
give_me_block do
  p "Hello, block!"  # => "Hello, block!"
end

# その内部にyieldを持っている以上「ブロックを引数として受けとるメソッドである」と認識しよう

# Procの実行方法

# 1. proc.call()
# 2. proc[aug...]
# 3. proc.(aug...)

# Proc と Lambda の違い

# 1. 引数の扱い
# Proc.new で作成した Proc オブジェクトでは、引数の数があっていなくても実行される
# lambda   で作成した Proc オブジェクトでは ArgumentError 

proc_obj   = Proc.new {|x, y| [x, y] }  #=> #<Proc:0x007ff96a8c8fc8@(irb):1> 
lambda_obj = lambda   {|x, y| [x, y] }  #=> #<Proc:0x007ff96a8d0d18@(irb):2 (lambda)> 

proc_obj[1]        #=> [1, nil] 
# lambda_obj.(1)   #=> ArgumentError: wrong number of arguments (1 for 2)


# 2. Proc オブジェクトのブロック内で return, break したときの挙動

# 【Proc オブジェクトの場合】

# Proc オブジェクトの中で return → Proc オブジェクトを call したコンテキストで return しようとする
# そのためトップレベルで call した場合、LocalJumpError となります。

# トップレベルで実行した場合
# proc { return 1 }.call   #=> LocalJumpError: unexpected return

# メソッド内で実行した場合 → OK
def foo
  proc { return 1 }.call
  return 2
end

foo #=> 1

# 【Lambda の場合】

# メソッド内で return したときと同様で、そのブロック内の処理を抜けるのでトップレベルで実行してもエラーとならない

lambda { return 1 }.call  #=> 1 


















