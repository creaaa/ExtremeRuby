
require 'optparse'
OptionParser.new {|opt|

  # 条件を事前に設定 (その後、 opt.parse! しないとせっかく書いたこれらは発動しない)
  #ここに設定した以外のオプション -z などを書いた場合、opt.parse!の行が InvalidOptionを投げる

  opt.on('-a', 'こんにちは。rubyはいいぞ。') {|v| p v }			# もし -a があれば、ブロック実行
  									# クロージャの引数 v には、true/falseが格納されている。
  									#　ある・なしのスイッチ的に使う、とのこと
  									# 第２引数を渡すと、 -h 時に表示される説明文を付加できる

  # opt.on('-b HO') {|v| p v }		# もし -bがなんらかの引数つきであれば、ブロック実行 (VALは何にでも書き換え可能で何の影響もない)
  								    # 引数がないと、opt.parse! がmissing argumentを投げる
  								    # v には、引数の文字列がそのまま入る。 -b Fuga だったら、"Fuga" と出る。

  # opt.on('-c [OPTION]') {|v| p v }# 引数は任意。
  								    # 引数がないと、v は nil. 引数があると、 vはその引数の文字列がそのまま入る

  # opt.on('-ch') みたいに、2文字でやった場合は? → v は "h" になる。 								   
  
  opt.parse!(ARGV)          
}
# p ARGV


#オプション定義が何もない状態でも、opt.parse!(ARGV)さえ実行しておけば、-hと--helpオプションが利用できる。

# 参考

# http://d.hatena.ne.jp/zariganitosh/20140819/ruby_optparser_true_power









