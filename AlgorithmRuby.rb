
# ポインタ
# a = []
# b = a

# a.push(1)
# p b  # [1]


# 原始的なリスト

# class Element

# 	attr_accessor :value, :next_ref

# 	def initialize(value, next_ref)
# 		@value    = value
# 		@next_ref = next_ref
# 	end

# end

# d = Element.new(4, nil)
# c = Element.new(3, d)
# b = Element.new(2, c)
# a = Element.new(1, b)

# # 先頭の値からすべての要素へアクセスできる
# p a.value  # 1
# p a.next_ref.value  # 2
# p a.next_ref.next_ref.value  # 3
# p a.next_ref.next_ref.next_ref.value  # 4



# リスト操作を備えたListクラス
class List
	def initialize()
		@first_element = nil
	end

	def unshift(value)
		element = Element.new(value, @first_element)
		@first_element = element
	end

	def push(value)
		if @first_element.nil?
			@first_element = Element.new(value, nil)
		else
			current_element = @first_element
			while (! current_element.next_ref.nil?)
				current_element = current_element.next_ref
			end
			current_element.next_ref = Element.new(value, nil)
		end
		self  # これなんの意味があるん
	end

	def each
		current_element = @first_element
		while (! current_element.nil?)  # nilでなければtrue
			yield current_element.value
			current_element = current_element.next_ref
		end
	end

	# ランダムアクセスを実現する
	def [](index)
		if index < 0
			return
		end

		current_index = 0
		current_element = @first_element

		loop do
			if current_element.nil?
				return nil
			elsif current_index == index
				return current_element.value # 正常実行。添字に対応する値を返す
			else
				current_index += 1
				current_element = current_element.next_ref
			end
		end
	end

end

## unshift, each を使う
# list = List.new
# list.unshift 4
# list.unshift 3
# list.unshift 2
# list.unshift 1

# list.each { |value| p value }


##  push を使う
# list = List.new
# list.push 4
# list.push 3
# list.push 2
# list.push 1

# list.each { |value| p value }

# # 添字でランダムアクセス
# p list[-1]  # nil
# p list[0]   # 4
# p list[1]   # 3
# p list[2]   # 2
# p list[3]   # 1
# p list[4]   # nil


# ハッシュ関数
# require "digest/md5"

# p Digest::MD5.hexdigest("foo")  # "acbd18db4cc2f85cedef654fccc4a4d8"
# p Digest::MD5.hexdigest("foo")  # "acbd18db4cc2f85cedef654fccc4a4d8"
# p Digest::MD5.hexdigest("foo")  # "acbd18db4cc2f85cedef654fccc4a4d8"

# p Digest::MD5.hexdigest("bar")  # "37b51d194a7513e45b56f6524f2d51f2"


# ハッシュテーブルの構造を定義
class HashTable
	BIN_SIZE = 4

	def initialize
		# '個数の指定'と'ブロック'の2つを渡すことで、配列の初期値を決定できるイニシャライザがある。
		# Swiftなら、さしずめ Array(repeating: [], count: 4) だろうか...
		@bins = Array.new(BIN_SIZE) do |i|
			List.new  # 空の配列が4個あり、それぞれの中には空の連結リストが代入されている
		end
	end
end

myHash = HashTable.new()
p myHash














