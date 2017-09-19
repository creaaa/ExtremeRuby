
# 3.5.9 ブロック

# %w(Alice Bob Charlie).each do |elem|
# 	puts "Hello, #{elem}!"
# end

# def my_block
# 	puts "stand up"
# 	yield if block_given?
# 	puts "sit down"
# end

# # my_block { p "un" }


# これはなかなかすごいな...
# proc = :upcase.to_proc
# p proc.call("hello")


 # 5

# enum = [4,4,2,3].to_enum

# p enum.next
# p enum.next
# p enum.next
# enum.rewind
# p enum.next
# p enum.next
# p enum.next
# p enum.next
# p enum.next
# enum.rewind

# ちなみにSwiftだとだいたいこんな感じで書く

# let ary = [1,2,3,4,5]
# var iter = ary.makeIterator()

# while let num = iter.next() {
#     print(num)
# }

# loop do
# 	#例外StopIterationはloopが捕捉してくれる
# 	puts enum.next
# end

# people = %w(Alice Bob Charlie).to_enum
# ages   = [14, 32, 28].to_enum

# loop do
# 	person = people.next
# 	age    = ages.next

# 	puts "#{person} (#{age})"
# end


# enum = %w(Alice Bob Charlie).select

# # eiにマッチする要素だけ取得

# loop do
# 	begin
# 		person = enum.next
# 		enum.feed /li/ === person
# 	rescue StopIteration => e
# 		p e.result
# 		break
# 	end
# end

# (0..Float::INFINITY).map {|n| n.succ }.select {|n| n.odd? }.take(3)  # 帰ってこない

# これならいける
# odd_numbers = (0..Float::INFINITY).lazy.map {|n| n.succ }.select {|n| n.odd? }.take(3)
# p odd_numbers.force # => [1, 3, 5]

# (0..Float::INFINITY).lazy.map { |n|
# 	puts "map: #{n}"
# 	n.succ
# }.select { |n|
# 	puts "select: #{n}"
# 	n.odd?
# }.take(3).force

# class Processor
# 	def process
# 		protected_process
# 	end

# 	def protected_process
# 		private_process
# 	end
#  	protected :protected_process   # protected_process

# 	def private_process
# 		puts "Done!"
# 	end
# 	private :private_process

# myProcessor = Processor.new

# myProcessor.process  # Done!

# protectedなメソッドは同じクラスかそのサブクラスのインスタンス「から」しか呼び出せない
# これは、「トップレベルからの呼び出し」という扱い、というのだろうか。。。。
# myProcessor.protected_process

# これもダメ
# myProcessor.private_process

# 6
# module Sweet
# 	def self.lot
# 		# sample() → 配列の要素を1つランダムに返す
# 		%w(brownie apple-pie bavarois pudding).sample
# 	end
# end

# p Sweet.lot()

# Mix-in

# module Greetable
# 	def greet_to(name)
# 		puts "Hello, #{name}. My name is #{self.class}."
# 	end
# end

# class Alice
# 	include Greetable

# 	def greet_to(name)
# 		super
# 		puts "Nice to meet you!"
# 	end

# end

# alice = Alice.new
# alice.greet_to("Bob")


# class FriendList
# 	include Enumerable

# 	def initialize(*friends)
# 		@friends = friends
# 	end

# 	def each
# 		for friend in @friends
# 			yield friend
# 		end
# 	end
# end

# friend_list = FriendList.new("Alice", "Bob", "Charlie")

# friend_list.map {|friend| p friend.upcase }
# p friend_list.find { |friend| /b/ === friend }

# p Class.ancestors  # [Class, Module, Object, Kernel, BasicObject]


# 8

# def hoge
# 	Proc.new
# end

# hoge{|fuga| puts fuga}  # 引数0のどんな関数にも、勝手にブロックを渡して実行できる！

# myHoge = hoge{|fuga| puts fuga}
# # 実行方法は3つある
# myHoge.call(42)
# myHoge[42]   # このサブスクリプト方式と
# myHoge.(42)  # この.()方式はガバガバやん...


# 9

# double = Proc.new { |x| x * 2 }
# p double.class  # Proc

# # Procオブジェクトの呼び出しはこう。
# p double.call(2)
# # もしくはこう
# p double.(2)

# ary = [1,2,3,4,5]
# # この:shiftシンボルを"shift"にしても結果は同じ
# ary_shift = ary.method(:shift)  #<Method: Array#shift>

# # Procと同じように使える
# p ary_shift.(3)  # [1, 2, 3]
# # Methodオブジェクトはレシーバを保持しているため、破壊的メソッドを実行するとオリジナルにも影響が及ぶ
# p ary  # [4,5]

# p ary_shift.name





