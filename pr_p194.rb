
someone = "Dave"

%w(Alice Bob Carol).each do |person; someone|
	someone = person
end

p someone  # Dave. つまりこうすることでローカル変数がブロックの影響を受けなくできる
# ただしこのコードは全く無意味。


# とりま、ブロック引数 someoneを書かなければこうなるのはわかるよな...

%w(Alice Bob Carol).each do |person|
	someone = person
end

p someone  # Carol