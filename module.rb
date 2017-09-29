
# モジュール、include, extend

require "pp"
require "Time"


##############################################
# きほん
##############################################

# [include]

# インクルードとは、指定されたモジュールの定義 (メソッド、定数) を引き継ぐことです。
# インクルードは多重継承の代わりに用いられており、 mix-in とも呼びます。

# [extend]

# 引数で指定したモジュールのインスタンスメソッドを self の特異メソッドとして追加します。
# Module#include は、クラス(のインスタンス)に機能を追加しますが、
# extend は、ある特定のオブジェクトだけにモジュールの機能を追加 したいときに使用します。
# (↓の結論の パターン3, 4に相当する。
# 2に関しても、まぁ基本クラスオブジェクトは1つしかないだろうから、何の語義矛盾もない。)
# 引数に複数のモジュールを指定した場合、最後の引数から逆順に extend を行います。


##############################################
# 【chapter 1: クラス定義内の inculde / extend】
##############################################

# module MyModule
# 	def instance_method
# 		:instance_method
# 	end

# 	# private
# 	def self.class_method
# 		:class_method
# 	end
# end

# class MyClass
# 	include MyModule
# end

# myClass = MyClass.new
# 1 クラスに includeでインポート

# [結論] インスタンスメソッド → ○ クラスメソッド → ×

# p myClass.instance_method # :instance_method
# p MyClass.instance_method  

# MyClassに直接定義された
# MyClass.method_defined? :instance_method  # true

# クラスメソッドは失敗

 # myClass.class_method			 # <NoMethodError> undefined method `class_method'
# p MyClass.class_method         # <NoMethodError> undefined method `class_method'


# 2 # クラスに extendでインポート

# [結論] インスタンスメソッド → ○(クラスメソッドとして取り込まれる) クラスメソッド → ×

# class MyClass
# 	extend MyModule  # self = MyClassオブジェクトの特異メソッドとしてインスタンスメソッドを追加
# end

# myClass = MyClass.new


# インスタンスメソッドとしては定義されないが...
# p myClass.instance_method  # :undefined method `instance_method'  # NoMethodError

# これだといける (moduleではインスタンスメソッドとして定義したメソッドが、extendするとクラスメソッドとして扱えるようになる)
# p MyClass.instance_method  # :instance_method

# 定義された場所は、 MyClass オブジェクト
# p MyClass.method_defined? :instance_method                  # false
# p MyClass.singleton_class.method_defined? :instance_method  # true

# クラスメソッドは無理
# myClass.class_method      # <NoMethodError> undefined method `class_method'
# p MyClass.class_method    # <NoMethodError> undefined method `class_method'


##############################################
# 【chapter 2: インスタンス変数orクラスオブジェクト への inculde / extend】
##############################################

# module MyModule
# 	def instance_method
# 		:instance_method
# 	end

# 	def self.class_method
# 		:class_method
# 	end
# end

# class MyClass
# end

# myClass = MyClass.new

# 1 インスタンス変数 / クラスオブジェクトに モジュールを include

# myClass.include MyModule  # undefined method `include' NoMethodError

# # ...エラーになった。なぜ? → インスタンス変数は Moduleクラスが継承ツリーにないから、includeメソッドを持たない(またやっちまった)
# # MyClass.ancestors # [MyClass, Object, Kernel, BasicObject]

# 一方、クラスオブジェクトに モジュールを include
# MyClass.include MyModule

# 呼べない
# MyClass.instance_method

# 呼べない
# p MyClass.class_method  # NoMethodError


# # 2. インスタンス変数に モジュールを extend

# # includeと違って、extendは呼べるのは、Object#extend だから
# myClass.extend MyModule

# # その結果は...
# p myClass.instance_method  # :instance_method

# # 上は、「オブジェクトの特異メソッド」扱いとなっている
# p MyClass.method_defined? :instance_method                  # false
# p MyClass.singleton_class.method_defined? :instance_method  # true

# クラスメソッドはダメ
# p myClass.class_method  # undefined method `class_method' NoMethodError


# 一方、クラスオブジェクトにextendする場合は...

# MyClass.extend MyModule

# p MyClass.instance_method  # :instance_method 呼べる
# p MyClass.singleton_class.method_defined? :instance_method # true.メタクラスに定義されている
# p MyClass.class_method     #  undefined method `class_method' NoMethodError


##############################################
# 検証の結果...
##############################################

# include / module で、メソッドが定義されるパターンは、
# 以下の4つしかない

# [A. クラス定義に書く場合]

# module MyModule
# 	def zikken_method
# 		:instance_method
# 	end

# 	def self.class_method
# 		:class_method
# 	end
# end

# 1. 【インスタンス変数】に【include】した場合、モジュールの【インスタンスメソッド】が加わる
# (定義場所は "オブジェクト"であり、"クラスオブジェクトと親クラスの中間地点" でもある(↓参照))

# class MyClass
# 	include MyModule
# end
# myClass = MyClass.new

# p myClass.instance_method  # :instance_method

# pp myClass.public_methods        # あった
# pp myClass.public_methods false  # ない

# →　この理由は、メソッドが、PRのいう「モジュールをラップした透明なクラス」に設定されており、
# それは "オブジェクトのクラス"と"その親クラス" の中間地点にあるため


# 2. 【クラスオブジェクト】に【extend】した場合、モジュールの【インスタンスメソッド】が<クラスメソッドとして>加わる
# (定義場所は クラスオブジェクトの特異クラス(=メタクラス))

# class MyClass
# 	extend MyModule
# end

# p MyClass.instance_method  # :instance_method

# [B. オブジェクトに足す場合]

# 3. 【インスタンス変数】に【extend】した場合、モジュールの【インスタンスメソッド】が加わる
# (定義場所は オブジェクトの特異クラス)

# class MyClass
# end

# myClass = MyClass.new
# myClass.extend MyModule

# p myClass.instance_method  # :instance_method

# 4. 【クラスオブジェクト】に【extend】した場合、モジュールの【インスタンスメソッド】が加わる
# (定義場所は クラスオブジェクトの特異クラス(=メタクラス))

# MyClass.extend MyModule
# p MyClass.instance_method  # :instance_method


##############################################
# 以上の類型を、 include / extend 別に分けてみると...
##############################################

# 【A. include】

# 1. 【インスタンス変数】に【include】した場合、モジュールの【インスタンスメソッド】が加わる(Mix-in) (P.245)

# 【B. extend】

# 2. 【クラスオブジェクト】に【クラス定義でextend】した場合、
# モジュールの【インスタンスメソッド】が<クラスメソッドとして>加わる(P.252)
# 3. 【インスタンス変数】  に【obj#extend】した場合、モジュールの【インスタンスメソッド】が加わる (P.251・495)
# 4. 【クラスオブジェクト】に【obj#extend】した場合、モジュールの【インスタンスメソッド】が加わる (なし)


##############################################
# 補足
##############################################

# 以上の4パターンからわかるように、モジュールに定義されたクラスメソッド(self.xxx)を加える手段は基本的にない。
# これは単に、Module名.xxx とすれば即効呼び出せたりするので、基本的に問題はない、と思われる。

##############################################
# モジュール関数
##############################################

# Math.sqrt 4  # 2.0

# include Math
# p sqrt 4     # 2.0

# 自分自身のクラス(Object)と親クラス(BasicObject)の間に Math が入っている。
# つまり、main#include といえど、他の includeの挙動と同じってことがわかる。
#  self.class.ancestors  # [Object, 【Math】, PP::ObjectMixin, Kernel, BasicObject]

# でも、 method_defined? はプライベートメソッドが出力されないので、
# こうしたらやっときた
# p self.private_methods  # [..., sqrt, ...] やっときた。

# つまり、main#include すると(多分self#include の場合も)、
# メソッドがオブジェクトに直接追加される。
# なかなか出力されなかったのは、privateだったから工夫しないといけなかったため。

# あと、これでもいけたな
# p self.respond_to? :sqrt        # privateメソッドには反応しない
# p self.respond_to? :sqrt, true  # こうすると反応する

# 余談だが、mainの特異クラスは、PP::ObjectMixin とかいう物体あったｗｗ
# p self.singleton_class.ancestors
	# [#<Class:#<Object:0x007fe1e18d64c0>>, Object, Math, PP::ObjectMixin, Kernel, BasicObject]


#######################
# main に 関数を追加する
#######################

# case.1) mainにインスタンスメソッドを追加

# def main_instance_method
# 	"mainなインスタンスメソッド"
# end

# [定義場所] → 「特異メソッドとして」「privateで」定義される

# pp self.private_methods                　# あった
# pp self.singleton_class.private_methods  # あった

###
# クソハマリポイント
###

# Object#methods
# Object#singleton_methods

# は、publicとprotectedなメソッドのみ返す。ハマった。注意。


# case.2) mainにクラスメソッドを追加(実験)

# def self.main_class_method
# 	"mainなクラスメソッド"
# end

# クラスメソッドとして追加してるつもりが、これで呼べてしまう
# p main_class_method

# この理由は、たぶんわかった。
# トップレベルの self は、mainオブジェクトの参照(×クラスオブジェクトの参照)とみなされ、
# 本来 self.xxx という記法でできたはずの、クラスメソッドの定義とみなされない。
# さしずめ、インスタンスメソッドの定義として解釈されているんだろう。

# ただし、謎なのが、case.2 は case.1 と全く同じ定義方法かと思いきや、
# [mainオブジェクト]に、[publicな] メソッドとして定義されていること。case.1 とだいぶ違う

# [定義場所] → 「mainオブジェクトに」「publicで」定義される

# pp self.public_methods  # あった
# pp self.singleton_class.methods  # ない 


# てことで、馬鹿な実験はやめ、素直に def Object.xxx しましょう。

# p "hello".to_sym


#######
# クソバマリ
#######

# Rubyリファレンスの、各クラス目次の「特異メソッド」って、これ、「クラスメソッド」のことだから注意。

# pp Time.methods false # あれ、あった
# pp Hash.methods false  # あった、でもリファレンスにはある new は出力されない、private_methodsでもだめ。なぜ
# pp Regexp.methods false # あった
# pp String.methods false # あった


greeting = "hello"

# 特異メソッドを追加すると...
def greeting.oppo
	:bye
end

greeting.public_methods false   # [oppo] 

# え、なんで特異クラスじゃなくてオブジェクトに直接付くの。。。
# → そう見えてるだけ。
# 定義されている場所は、"オブジェクト"に見えるが、正確には「オブジェクトの特異クラス」。
# xxx_methods false の出力対象は、「オブジェクトの特異クラス」「オブジェクトのクラス」まで含むので、
# 「オブジェクトの特異クラス」に定義されている oppo も入る、ってだけ。

# 次の謎

# p greeting.singleton_class.methods false  # [:try_convert]
# ↑ の結果と、↓の結果が一致する理由、ちゃんとわかってる??
# String.methods false # [:try_convert]  # こっちはカンタン

# falseを渡すと、singleton_methods(false) と同じ挙動、つまりそのオブジェクトの特異メソッドだけを返す
# これは、自分の特異クラスへ辿り、そこの特異メソッドを「フェッチしてくる」イメージに近い。
# [greetingの特異クラス・オブジェクト]から見て、自分の特異メソッドが定義される場所とは、
# [greetingの特異クラス・オブジェクト]の親クラスのオブジェクトの特異クラス = Stringのメタクラス。

# p greeting.methods false                  # [:oppo]

# pp greeting.public_methods false

#p greeting.singleton_class.methods false  # [:try_convert]


class String 
	# こっちはStringクラスに定義されるのはわかりやすい
	def bye
		"Bye..."
	end
	# でもこうして並べると、こっちはClass型のクラスオブジェクト(String)に紐づくってわかると思う
	# Classオブジェクトに紐づく特異メソッドがクラスメソッドであり、
	# クラスメソッドが定義される場所 = Classオブジェクトの特異クラス = メタクラス
	def self.bye
		"Class Bye..."
	end
end

# クラスメソッドとは "Class型オブジェクトの特異メソッド"なので、クラス定義外でも書ける。
# これは既に同名の特異メソッドが定義されているので、 "上書き"となる
def String.bye
	"another class bye..."
end


# こうして並べると、クラスメソッドの呼び出しも 単なるふつうの インスタンスメソッドに見えてくるはず...
"Hello".bye
String.bye   # "another class bye..."  Stringは実際のところ、他と全く同じ "ただのClassクラスのインスタンス"

AnotherString = String
AnotherString.bye    # "another class bye..."

# p String.methods false
AnotherString.public_methods false


# 実は特異クラスは、オブジェクトのクラスのサブクラスとなっています。

"hello".singleton_class.class       # Class
"hello".singleton_class.superclass  # String

# メタクラス(クラスオブジェクトの特異クラス)
p String.singleton_class.class       # Class メタクラスといえども、型はClassなんだね
p String.singleton_class.superclass  # #<Class:Object> Objectクラスの特異クラス(型は相変わらず Class)

p String.ancestors  # 親は Objectクラス
p String.class  # Class
p String.class.superclass



# 特異クラスを参照渡ししたらどうなるか

p "unko"

# 特異クラスの親子関係は独特だ。

# 独自クラスの特異クラスの継承関係は、こう
# p String.singleton_class.ancestors
# <Class:String>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object,
# PP::ObjectMixin, Kernel, BasicObject]

# Classクラスの特異クラスの継承関係は、こう
# p Class.singleton_class.ancestors
# <Class:Class>, #<Class:Module>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object,
# PP::ObjectMixin, Kernel, BasicObject]

# そして、すべての始祖、BasicObjectの特異クラスだってこのとおり。
# BasicObject.singleton_class.ancestors  # [#<Class:BasicObject>, Class, Module, Object,
# PP::ObjectMixin, Kernel, BasicObject]






