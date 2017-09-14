
# この連載が役に立つ(全３回)
# http://www.buildinsider.net/language/rubytips/0021

# 1. すべての行をread
# f = File.open("./wordlist.txt")  # 型: File
# s = f.read  # 全て読み込む。型: String
# f.close
# p s  # "apple\norange\nbanana\npeach\nkiwi\ngrape\n"

# File#open
# 1st param: ファイルパス
# 2nd param: ファイルモード(default = 'r')
# 3rd param: ファイルを生成する場合のchmod (default = 0666)
# 失敗時、 Errno::EXXX を投げる




# macOSのテキストファイルでは改行文字をLFとするのが一般的であり、
# Windowsでは改行文字をCRLFとするのが一般的だが、
# LFは\nと表示され、CRLFは\r\nや\n（※実行環境や後述するモード指定などによって異なる）と表示される。

# 1. の書き換えはこう
# s = ""
# File.open("wordlist.txt") { |file| s = file.read }
# p s  # "apple\norange\nbanana\npeach\nkiwi\ngrape\n"

# かつ、openにブロックを渡すと、
# ブロック終了時、ファイルを自動クローズする、という挙動になる

# 2. 本題。1行ずつreadするには

# getsはEOFでnil, readlineはErrorを投げる
# File.open("wordlist.txt") { |file|
# 	p file.gets  # 1行目       "apple\n"
# 	p file.gets  # 2行目
# 	p file.gets  # 3行目
# 	p file.gets  # 4行目
# 	p file.gets  # 5行目
# 	p file.gets  # 6行目
# 	p file.gets  # 7行目(ない)  nil
# 	p file.readline # 8行目(ない)　(EOFError)
# }

# 汚いので書き換えよう。すべての行を1行ずつ読み込む

# IO.foreach: ファイルの各行を引数に、ブロックを繰り返し実行
# 1st: ファイルパス
# 2nd: 行の区切り文字(default: $/)
#File.foreach("wordlist.txt"){ |line|
#  p line  # 結果は↑と同じ
#}

# 読み込んだ行を配列で返す readlines
# s = []
# File.open("wordlist.txt", "rt") { |file|
# 	s = file.readlines
# }
# # 改行文字も入ってしまう...
# p s  # ["apple\n", "orange\n", "banana\n", "peach\n", "kiwi\n", "grape\n"]

# 改行文字をトリムするにはこうじゃ
# s = []
# File.foreach("wordlist.txt") { | line |
# 	s << line.chomp # <<: 配列に要素を追加。String#chomp = 文字列末尾の改行文字を削除
# }
# p s  # ["apple", "orange", "banana", "peach", "kiwi", "grape"] 😎

########## これらをふまえまして #####

=begin
s1 = []
s2 = []

File.foreach("wordlist.txt") { | line |
	s1 << line.chomp # <<: 配列に要素を追加。String#chomp = 文字列末尾の改行文字を削除
}

File.foreach("wordlist2.txt") { | line |
	s2 << line.chomp # <<: 配列に要素を追加。String#chomp = 文字列末尾の改行文字を削除
}

# p s1
# p s2

p s1 | s2  # 和集合  ["apple", "orange", "banana", "peach", "kiwi", "grape", "tomato", "sprout"]
p s1 - s2  # 差集合  ["orange", "peach", "kiwi", "grape"]。第1引数の集合が基準
p s2 - s1  #        ["tomato", "sprout"]
p s1 & s2  # 積集合  ["apple", "banana"]
=end


# ついでにコマンドライン引数もやりましょう

# $0 =  コマンド名
# ARGC: コマンドに渡した引数名。[]でアクセス可能

# puts "filename: #{$0}"

# ARGV.each_with_index do | arg, i |
# 	puts "ARGV[#{i}]: #{arg}"  # i = 0スタート
# end

# コマンドライン引数のファイルを読み込む

# f = open(ARGV[0])
# while line = f.gets  # すなわち、行がなければnil = ループエンド
# 	puts line # なんか改行文字も勝手にトリムしてくれる。便利。
# end


##### もうできるな?? #####

# 1. store each file path

filePaths = []

ARGV.each { |filePath|
	filePaths << filePath
}

# 2. prepare a set of set by the number of file

# get the number of file
ARGV.length.times do |num|  # starts from 0
	var = "@words#{num}"
	eval("#{var} = []")
end

# p("配列1, ", @words0)
# p("配列2, ", @words1)
# p("配列3, ", @words2)

# 3. make each wordlist's set

ARGV.each_with_index do |path, num|
	f = open(path)
	while line = f.gets
		eval("@words#{num} << line.chomp")
	end
	# f.close
	# puts eval("@words#{num}")
	# puts "\n"
end

# 4. calculate!
# p @words0 | @words1  # 和集合  ["apple", "orange", "banana", "peach", "kiwi", "grape", "tomato", "sprout"]
# p @words0 - @words1  # 差集合  ["orange", "peach", "kiwi", "grape"]。第1引数の集合が基準
# p @words1 - @words0  #        ["tomato", "sprout"]
# p @words0 & @words1  # 積集合  ["apple", "banana"]

# convert set to string

result = @words0 | @words1

result.each { |word| puts word }




















