
someone = "Dave"

%w(Alice Bob Carol).each do |person; someone|
	someone = person
end

p someone  # Dave. つまりこうすることでローカル変数がブロックの影響を受けなくできる
# ただしこのコードは全く無意味。

# とりま、ブロック引数 someoneを書かなければこうなるのはわかるよな...

# %w(Alice Bob Carol).each do |person|
    # 引数にとらなければ、外部を見に行き、あればそれが「キャプチャ」されてしまう、って挙動。
    # それを防ぐために、「ブロックローカル変数を定義するためのコンマ」ってことか。
# 	someone = person
# end

# p someone  # Carol