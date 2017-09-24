
# class Klass
#   def self.class_method
#     :class_method
#   end
# end

# 実は、クラスメソッドは、self.xxx ではなく、クラス名.xxx でも定義できる！
# class Klass
#   def Klass.class_method
#     :class_method
#   end
# end

# p Klass.class_method  # :class_method


# それは、こうすればなんとなく見えてくる
# class Klass
#   def (p self).class_method  # このコードやばｗｗｗｗｗ Swift絶対無理ｗｗｗｗｗ
#     :class_method
#   end
# end

hoge = -> str { str.upcase }
p hoge.call "hi"




