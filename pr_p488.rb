
# class OriginalClass
# end

# obj = OriginalClass.new

# def obj.new_singleton_method
# 	:new_singleton_method
# end

# p obj.class.method_defined? :new_singleton_method  # false
# p OriginalClass.method_defined? :new_singleton_method  # false

# # 特異クラスは、Object#singleton_class で取れる
# p obj.singleton_class.method_defined? :new_singleton_method  # true

########

class Klass
end

klass = Klass.new

# klassインスタンスに対応する特異クラスを生成する、ってことかな
k = class << klass

	# Rubyはトップレベルに限らずどこでも実行コードを書け、実行できるのはご存知のとおり。
	# で、「class定義に実行コードが含まれていた場合、最後の式を返り値として返す」仕組みになってるんだと思う。
	# すなわち、↓のように書くことで、return self扱いで、クラス定義のくせにインスタンスまで返せるようになる。
	self  # class << xxx 内の selfは、"特異クラスのインスタンス"を意味する。この場合特異クラスが返る。
end

# 通常、"クラスインスタンス"の .classの結果は、クラス名(ただしこれだって、Classクラスのオブジェクトであることには変わらない、はず)
p klass.class    # Klass <Klass:0x007fe02d160f48>
# 一方、"特異クラスインスタンス"の .class の結果は、必ず Class
p k.class        # Class  <Class:#<Klass:0x007fb2e3945320>>

KLASS_OBJECT = klass
p k == klass.singleton_class #=> true

ppp = class UNKOKKO
	42
end

p ppp



