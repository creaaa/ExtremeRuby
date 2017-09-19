
#ドットインストール Ruby入門

 
# 1 イントロ

# REPLで実行 →          $ irb 
# マニュアルをCLIで見る → $ ri Array(クラス名)

# 2

=begin
複数行の
コメントアウトです
=end

=begin
print "hello ruby world" # 改行なし
puts  "hello world"      # 改行あり
p     "p だよ"           # デバッグ用。オブジェクトの種類がわかりやすいよう、 "" で囲んで表示してくれたりする
=end


# 3 変数と定数

=begin

# 変数は、英小文字 or _ ではじめないとだめ。脅しではなく、これは言語レベルの強制である。

msg = "hello"

# 定数は、英大文字。これで実際に再代入不可にしてくれる...
# はずだが、実際は再代入でき、かつ警告が出るのみで、
# プログラムは死なずに動き続ける。うーん...
# 慣習的には全部大文字の名前の場合が多い。

Msg = "constant"
p Msg  # constant

=end


# 4 オブジェクト

# Rubyはすべての値がオブジェクト


# 5 数値オブジェクト

# オブジェクトがどのクラスに属するか、どんなメソッドを持つか調べる

# p 42.class    # Integer
# p 42.methods  # [:%, :&, :+, succ, :next...]

# p 15 ** 2  # 累乗。225。
# p Rational(2,5)  # 2/5
# p 2/5r           # 2/5。↑の糖衣構文。


# 6 文字列

=begin
# ダブルクオートとシングルクオートの違い
	# ダブルクオートは特殊文字使用可能、式展開ができる

# 特殊文字
puts  "hello\no worl\td"
# 式展開
puts "price #{3000 * 4}"  # price 12000
puts 'price #{3000 * 4}'  # price #{3000 * 4}

name = "taguchi"
puts "hello #{name}"

puts "hello" + "world"  # helloworld
puts "hello" * 5        # hellohellohellohellohello

=end


#7 ? や ! がついたメソッド

# ! 破壊的メソッドであることを示す(そうゆうふうなAPIデザインになっている、ってだけの話だと思う)

# ―upcase
# -upcase! 破壊的メソッド

# name = "taguchi"
# puts name.upcase   # TAGUCHI
# puts name          # taguchi

# # オリジナルのnameを破壊する 
# puts name.upcase!  # TAGUCHI
# puts name          # TAGUCHI

# ? 真偽値を返すメソッドであることを示す

# name = "taguchi"
# puts name.empty?          # false
# puts name.include?("g")   # true


# 8 配列

=begin

colors = ["red", "green", "blue"]

p colors     # ["red", "green", "blue"]
p colors[0]  # "red"
p colors[3]  # nil (プログラムは死なない)

p colors[-1] # "blue" :  末尾の要素を返す。便利かもしれん
p colors[-2] # "green" : 末尾より1つ前の要素を返す。

p colors[0..2]  # ["red", "green", "blue"] Swiftでいう0...2
p colors[0...2] # ["red", "green"]. Swiftでいう0..<2。逆なのでわかりにくい...

# 要素の変更
colors[0] = "yellow"
colors[1..2] = ["white", "black"]
p colors    # ["yellow", "white", "black"]

# 追加
colors.push("gold")
colors << "silver"  # pushの糖衣構文
print(colors)

# 要素のサイズ
# (プロパティでもメソッド() でも両方いけた。ガバガバやん...)
	# → 引数なしのメソッドコールは()省略可能、という言語の機能でした
p colors.size  # 5
p colors.sort  # ["black", "gold", "silver", "white", "yellow"]

=end

# 9 ハッシュ

# :xxx は、シンボル = 英語しか使えないが軽い文字列みたいなもの
# { :hoge => 'hoge', :fuga => 'fuga'}

# v1.9以降は、こう書ける。↑ と等価。
# すなわち hoge, fugaはシンボル扱い。
# datas = { hoge: 'hoge', fuga: 'fuga'}

# get / set
# p datas[:hoge]
# datas[:fuga] = "peropero"
# p datas

# # ハッシュのメソッド
# p datas.size
# p datas.keys
# p datas.values
# p datas.has_key? :hoge
# p datas.has_key? :un


# 10 オブジェクト変換

# 破壊的ではなく、その都度変換したオブジェクトを返すだけだよ。


=begin 

x = 50
y = "3"

# p x + y   # エラー。てかこれできるのJavaScriptだけで、あれがやばすぎるだけなのか...意外と自制心あった

# to integer
p x + y.to_i
# to float
p x + y.to_f
# to string
p x.to_s + y


# ハッシュと配列の相互変換

scores = {taguchi: 200, fkoji: 400}

# ハッシュ → 配列
p scores.to_a  # [[:taguchi, 200], [:fkoji, 400]]
# 配列 → ハッシュ (to_hash, to_a, どちらでもOK)
p scores.to_h # {:taguchi=>200, :fkoji=>400}

=end

# 11 % 記法

=begin

# ダブルクオートで囲ったものは、こうも書ける
puts "hello"
puts %Q(hello)
puts %(hello)  # %Qの糖衣構文。やりすぎ。

# シングルクオートで囲ったものは、こうも書ける
puts "bye"
puts %q(bye)

# なにがいいのか?
# 例えば、ダブルクオートの中でダブルクオート使いたいときは、こうしなきゃダメ
# マジか。不便やん。

# puts "he"llo""  # ×
puts "he\"llo\""  # ◎

# それが、%記法使うと、こうじゃ
puts %Q(he"llo")  # バックスラッシュいらず。リーダブル。

# 他にもこんな%記法がある

p ["red", "blue"]
p %W(red blue)     # ダブルクオート

p ['red', 'blue']
p %w(red blue)     # シングルクオート


# 糖衣構文多すぎ。
# Rubyはキメると気持ちいいとかいってんのは、自制心のないプログラマが自分勝手にハイになってるんだということを知った。

=end


# 12 書式付きで値を埋め込む

# s / string
# d / decimal
# f / float

# p "name: %s" % "masa"     # "name: masa"
# p "name: %10s" % "masa"   # "name:       masa"
# p "name: %-10s" % "masa"  # "name: masa      "

# p "id: %05d, rate: %10.2f" % [355, 3.284]

# print("name: %10s\n" % "masa")

# 13

# score = gets.to_i

# if score > 80 then
# 	puts "great!"
# elsif score > 60 then
# 	puts "good!"
# else
# 	puts "soso..."
# end

# 後置if
# puts "great!" if score > 80

# 14

# signal = gets.chomp

# case signal
# when "red" then
# 	puts "stop"
# when "green", "blue" then
# 	puts "go"
# when "yellow" then
# 	puts "caution"
# else  # defaultじゃないんか。。。。
# 	puts "wrong signal"
# end

# 15 while, times

# i = 0
# while i < 10 do
# 	puts "#{i} hello"
# 	i += 1
# end

# timesメソッド(数字オブジェクトに属する)

# 10.times do |boke|
# 	puts "#{boke} hello"
# end

# 中身が1行の場合は、 ↑は{}を使って書ける
# Pythonと同じように、Rubyもブロックの中身は1行しか書けないのかも...?

# 10.times { |boke| puts "#{boke} hello" }


# 16 for繰り返し

# for i in 15..20 do # このdoは省略可能
# 	p i  # 15 16 17 18 19 20
# end

# # 15..20 の部分は、もちろん配列でもハッシュでもOK

# for color in ["red", "blue"] do
# 	p color
# end

# for name, value in {taguchi:200, fkoji:400} do # このdoは省略可能
# 	# taguchi: 200
# 	# fkoji: 400
# 	puts "#{name}: #{value}"
# end

# for は、内部的には eachというメソッドを使っている

# (15..20).each do |i|  # この場合のdoは省略不可
# 	p i  # 15 16 17 18 19 20
# end

# もちろん、中身が1行なので、こうも書ける
# (15..20).each { |i| puts i }

# 17

# i = 0
# loop do
# 	p i
# 	i += 1
# end

# 10.times do |i|
# 	if i == 7
# 		# break
# 		next
# 	end
# 	p i 
# end

# 18  メソッド

=begin

# def sayHi  # 引数0の場合、()がない！
# 	puts "Hi"
# end

# 呼び出しは()なしでOK、あってもよい
# 引数をとらないメソッドのみOK、ってことか
# sayHi
# sayHi()

# 引数をとるメソッド

# デフォルト値も渡せます
def sayHi(name="tom")
	# puts "Hello, #{name}!"

	# メソッドは実は最後の行を返すので、こうも書ける
	"Hello, #{name}!"

end

sayHi("Masa")

# 「意味があいまいにならない場合」、()は省略可能
# puts の引数の構文の意味がやっとわかった...
sayHi "Masa"  # Hello, Masa!

p sayHi         # Hello, tom!

=end


# 19 クラス定義

# 必ず大文字から始めないとダメ、コンパイルエラー。
# class User

# 	# .new時に呼ばれる特殊なメソッド
# 	def initialize(name)
# 		# インスタンス変数は @ で始まるルール
# 		@name = name
# 	end

# 	def sayHi
# 		puts "Hi! I am #{@name}"
# 	end

# end

# # インスタンス生成
# tom = User.new("Tom")
# tom.sayHi

# bob = User.new("Bob")
# bob.sayHi

# # 話がそれるが、オブジェクトが持つすべてのインスタンスメソッドをみたいならこう
# # print User.instance_methods  # 親や祖先が持つメソッドまで含む
# print User.instance_methods false  # 親や祖先が持つメソッドは除く

# じゃ、インスタンス変数を直接取得したかったらどうなるの?
# puts tom.@name  # これはエラー

# 主な答えは、「アクセサを用意する」

# attr_accessor :name  # ← これをクラスに追加する

# これにより、
# 1. name  (getterメソッド)
# 2. name= (setterメソッド)
# の2つのメソッドが追加される。


# 20 アクセサ

=begin

class User

	# 自動的に、nameという名前の getter/setterを作ってくれる
	# getterだけ作りたい場合は、attr_reader にする
	attr_accessor :name

	def initialize(name)
		@name = name
	end

	def sayHi

		#puts "Hi! I am #{@name}"

		# getterが設定されている場合は、getterをつかってこうも書ける
		# puts "Hi! I am #{self.name}"

		# selfは意味があいまいにならない限り、省略可能
		puts "Hi! I am #{name}"

	end

end


tom = User.new("Tom")

# アクセサを使用する
tom.name = "Tom jr"  # setter
puts tom.name
tom.sayHi

=end


# 21 クラスメソッド、クラス変数

=begin 

class User

	## クラス変数は、 @@ で始めればOK
	@@count = 0

	## クラス定数は 英大文字から始めればOK、@@いらない！注意
	VERSION = 1.1

	def initialize(name)
		@name = name
		@@count += 1
	end

	# メソッド名に self. を付けるとクラスメソッドになる
	def self.info
		puts "User class "
		puts "#{@@count} instances."
	end

end


alice = User.new("Alice")
# クラスメソッドの呼び出しはこう
User.info

bob   = User.new("Bob")
User.info

conan = User.new "Conan"
User.info

# クラス定数はこう使う
puts User::VERSION

=end


# 22 クラス継承

=begin 

class User

	## クラス変数は、 @@ で始めればOK
	@@count = 0

	## クラス定数は 英大文字から始めればOK、@@いらない！注意
	VERSION = 1.1

	def initialize(name)
		@name = name
		@@count += 1
	end

	# メソッド名に self. を付けるとクラスメソッドになる
	def self.info
		puts "User class "
		puts "#{@@count} instances."
	end

	def sayHi

		#puts "Hi! I am #{@name}"

		# getterが設定されている場合は、getterをつかってこうも書ける
		# puts "Hi! I am #{self.name}"

		# selfは意味があいまいにならない限り、省略可能
		puts "Hi! I am #{@name}"

	end

end

class AdminUser < User

	# オーバーライド可能。
	def sayHi
		puts "from admin!!"
	end

	def sayHello
		puts "Hello from #{@name}"
	end

end

tom = AdminUser.new "tom"
tom.sayHi
tom.sayHello

=end


# 23 アクセス権

# - public, private, protected(特殊)

# public = デフォルト。
# ただし！「initializeメソッド」と「クラス外に書いたメソッド」は自動的にprivateになる。

# private = 「レシーバーを指定できないメソッド」。クラス内からなら呼び出せる。
# 「レシーバーを指定できない」ため、self.xxx ではなく、必ずselfは省略して呼び出すこと！！
# (レシーバー(この場合はself)を指定できないため)

=begin

class User

	def initialize(name)
		@name = name
	end

	def sayHi
		puts "hi"
		sayPrivate  # self.sayPrivate とは書けない
	end

	# レシーバーを指定できない
	private

	def sayPrivate
		puts "private!!"
	end

end


# プライベートなメソッドは、インスタンス変数から呼べない
# User.new.sayPrivate  # NG

# ただし、クラスの中からなら呼び出せる。
tom = User.new("Tom").sayHi

=end

# swiftって、子クラスから親クラスのprivateメソッド呼び出せるっけ...??

# 24, 25 モジュールの用法(名前空間、ミックスイン)

# モジュール: インスタンスを作ったり継承したりができない

# モジュールの主目的の1つに、「名前空間として使う」用法がある
# 似たようなメソッドをまとめてグループ化できる。

=begin

# 必ず最初は大文字じゃないとエラー
module Movie

	VERSION = 1.1

	# クラスメソッドみたいに、self.xxxと書こう
	def self.encode
		puts "encoding..."
	end

	def self.export
		puts "exporting..."
	end

end

# モジュールを使う
Movie.encode
puts Movie::VERSION


# モジュールは、mix-inとして使う用法もある

# mix-in は、継承関係にない2つのクラスに対し、共通の機能を提供する場合に便利

module Debug
	# ↑の例のように self.xxx 「ではなく」、
	# ふつうにインスタンスメソッドのように定義すると、
	# このメソッドを、他のクラスのインスタンスメソッドとして「差し込める」ようになる。
	# これを mix-in という。
	def info
		puts "#{self.class} debug info..."
	end

end

# モジュールをmix-inするには、include を使う。
# これにより、モジュール内のメソッドを使えるようになる
class Player
	include Debug
end

class Monster
	include Debug
end

Player.new.info
Monster.new.info

=end


# 26 例外

=begin 
x = 0   # gets.to_i

# 例外処理の書き方

# 例外が発生しそうな処理を、begin-endで囲う

begin
	p 100 / x  # 本来であれば ZeroDivisionError

# rescue Exception => e
rescue => ex
	p ex.message  # エラー名の表示
	p ex.class    # エラーしたクラスを表示

	# もちろん独自処理も行える
	puts "Stopped!"

# 例外が発生しようがしまいが、必ず実行したい処理
ensure
	puts " -- END --"

end

=end


# 独自エラークラスも作れる

=begin

class MyError < StandardError; end

x = 3

begin
	if x == 3
	# エラーを明示的に投げる(要はthrow)
		raise MyError
	end

rescue MyError
	puts "MyError!!!!!"

rescue => ex

ensure
	puts " 「無」が訪れた- "

end

=end




