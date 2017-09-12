
# 関数(def)を変数に格納する、という概念はRubyにはない??


=begin 
def unko
  # 何も書かない場合、戻り値は NilClassになる
end

func = unko       # 変数に関数を格納する、という概念はないように思われる。
          # なぜなら、この場合、関数の代入ではなく、関数の実行(そしてその戻り値を変数に代入)という挙動なので。
          # 関数を変数を格納するならば、proc にするしかない、と思われる。
print func.class  # NilClass
=end

# 【重要】

# Pythonがサポートしている無名関数はラムダ式のみですが、
# Rubyはブロック、Procオブジェクト、ラムダ式といった種類の無名関数があります。


# 【基本】ブロック付メソッド呼び出し

# pattern 1
# [1,2,3].each do |i| print i*2, "\n" end
# pattern 2 (結果は1と同じ)
# [1,2,3].each {|i| print i*2, "\n" }

# do end と {} の違い → {}のほうが結合が強い。
# ただ、これに依存するコードは書いてはいけない。
# 参考: http://mickey24.hatenablog.com/entry/20100914/1284475769

# Rubyのfor文は、実は内部的にはeachメソッドを使用している



# 手続きオブジェクト(Proc) (多言語のクロージャ、'変数に入った関数')

# proc = 「ブロックをオブジェクト化したもの」

=begin 

myProc = proc { |v|
	p v
}

[1,2,3].each(&myProc)  # 1 2 3

# つまり、each() は、「'1つの引数を取るブロック'を1つ引数に取るメソッド」。
# ...とも限らなかった。こんなこともできた

# 例)hash
sum = 0
outcome = {'join' => 1000, "shopping" => 1000, 'food' => 4000}
outcome.each do |item, price|
  sum += price
end
puts sum  # => 6000

=end

# 違う例でもっと練習しよう。

# & = 「ブロックをprocに変換するよ」、という意味
def block(&the_block)
	the_block  # ブロックが返る
end

adder = block { |a, b| a + b }
p adder.class  # proc  (ブロックを格納する変数の型は、 Proc になる)

# これを使うには、Procオブジェクトが持つcall()メソッドを使う
p(adder.call(42, 1))

# proc と lambda は、基本コンセプトは同じなので安心していいが、細かい挙動が異なる。



=begin 

# 引数に & をつけると、ブロックを受け取ります。元々は繰り返し処理のために実装されたため、ブロックはイテレータとも呼ばれます。

def hello(cnt, &block_arg)
  cnt.times do
    block_arg.call
  end
end

#hello(3) { print "Hello " }       #=> Hello Hello Hello

=end


# yield

# 「ブロックを呼び出す物」
# yieldは、イテレータを定義するために、クラス／メソッド定義 で使用する

#
# case 1
#

# ブロック付きメソッドの定義、
# その働きは与えられたブロック(手続き)に引数1, 2を渡して実行すること
def foo
  yield(1,2)
end

# fooに「2引数手続き、その働きは引数を配列に括ってpで印字する」というものを渡して実行させる
foo { |a, b|
  p [a, b]
}  # => [1, 2] (要するに p [1, 2] を実行した)

# 今度は「2引数手続き、その働きは足し算をしてpで印字する」というものを渡して実行させる
foo {|a, b|
  p a + b
}  # => 3 (要するに p 1 + 2 を実行した)

# 
# case 2
# 

# 今度のブロック付きメソッドの働きは、
# 与えられたブロックに引数10を渡して起動し、続けざまに引数20を渡して起動し、
# さらに引数30を渡して起動すること
def bar
  yield 10
  yield 20
  yield 30
end

# barに「1引数手続き、その働きは引数に3を足してpで印字する」というものを渡して実行させる
bar {|v|
  p v + 3
}
# => 13
#    23
#    33 (同じブロックが3つのyieldで3回起動された。
#        具体的には p 10 + 3; p 20 + 3; p 30 + 3 を実行した)




