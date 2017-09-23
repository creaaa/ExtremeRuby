
class Hoge

	# これでインスタンス変数の定義はできない。
	# @unko = 42

	# するには、アクセサ設定 (+ initializerで初期値設定) するのが常道。
	#　attr_accessor :unko

	# 正確には、アクセサ設定はなくてもいいんだけど、attr_xxx を書いた際に暗黙定義されるgetterが使えないので、
	# アクセスするには「自分でゲッター・セッターをわざわざ書かなくてはいけな」くなる、というのが正解。
	#  (逆に言えば、書けば問題なく使える。)
	# ( ↓の getUnko のようなgetterをわざわざ書かなくてはいけなくなる、ということ)

	# インスタンス変数は、「すべての名前の変数が最初から定義されている」扱いとなっている。
	# だから ↓ のように、いきなり @unko と書ける。
	# ∵ (@unkoは 俺が書こうと思った"ずっと前から既に定義されていた"ため)
	# この意味はよく考えればわかるはず。俺は少なくとも1回はわかった

	# インスタンス変数は、 p Hoge.new.unko や、 p Hoge.new.@unko という風にはアクセスできない。
	# 正確には、もし前者でできるならば、絶対に attr_accessor か attr_reader を書いており、暗黙的に定義されているから可能、なはず。
	# インスタンス変数へのアクセサは必ずメソッド経由で、というRubyの仕組みをここに垣間見ることができる。
	def unko(newVal)
		@unko = newVal
	end

	def getU
		@unko
	end

	# なお、ふつーの「定数」であれば問題なく可能。
	SINRI = 42

	# def initialize
	# 	@unko = 42
	# end
end

myHoge = Hoge.new
myHoge.unko 43
p myHoge.getU

# なお、「グローバル変数($xxx)も、最初からすべての名前の変数があらかじめ定義されている」扱いとなる。
p $enopyon  # nil

###

p1 = Proc.new{|val| val.upcase}
p2 = :upcase.to_proc

p p1 == p2     # 同値ではなく...
p p1.eql?(p2)  # 当然同一でもない(別オブジェクト)が...

# 結果は結果的に同じになる
p p1.call("hi")
p p2.call("hi")

people = %w(Alice Bob Carol)
p people.map(&:upcase)








