
# 9

# class Yuffy
# 	# attr_accessor :cutiness

# 	def initialize
# 		# selfを忘れると...nilに
# 		# (ローカル変数の設定になってしまう)
# 		# cutiness = 42
		
# 		# selfをつけましょう。これにより、setterの呼び出しとなる
# 		# self.cutiness = 42

# 		# ぶっちゃけこれがベスト
# 		# @cutiness = 42
# 	end

# 	def getCutiness
# 		@cutiness
# 	end

# end

# Yuffy.new.getCutiness

# 10

require "csv"

# ハッシュを使うとこうだが...
# class AnnualWeather
# 	def initialize (file_name)
# 		# 配列を初期化し、その中にhashを格納する...という構造
# 		# Array<[String:Int]> みたいな構造か。
# 		@readings = []

# 		CSV.foreach(file_name, headers: true) { |row|
# 			@readings << {
# 				:date => Date.parse(row[2]),
# 				:high => row[10].to_f,
# 				:low  => row[11].to_f
# 			}
# 		}
# 	end
# end

# class AnnualWeather
# 	# 観測データを保持する新しいstructを作る
# 	Reading = Struct.new(:date, :high, :low)

# 	def initialize(file_name)
# 		@readings = []

# 		CSV.foreach(file_name, headers: true) { |row|
# 			@readings << Reading.new(Date.parse(row[2]),
# 									 row[10].to_f,
# 									 row[11].to_f)
# 		}
# 	end
# end

# 構造体のメソッド定義　やってみた

Yuffy = Struct.new(:cutiness) {
	def hello
		:hello!
	end

	def self.daifuku
		:daifuku
	end
}

myYuffy = Yuffy.new(80)
myYuffy.hello
Yuffy.daifuku

Struct.new(:unko).class

# 14











