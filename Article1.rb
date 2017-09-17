
# http://www.atmarkit.co.jp/ait/articles/1501/06/news028_2.html

# トップレベルでの「self」(すなわち現在のオブジェクト)は「main」である。そのクラス名は「object」.
# つまり「トップレベルでは、「self」は「Object」クラスのオブジェクトである」。

p self        # main
p self.class  # object

# クラス定義の中では、「self」はRabbitクラスそのもの
#（Rubyではクラスそのものも、「Class」クラスのオブジェクトであることを思い出せ(??)）
class Rabbit
  p self        # Rabbit
  p self.class  # Class

  # メソッド定義の中では、「self」はRabbitクラスのオブジェクト
  def jump
    p self        # #<Rabbit:0x007f9230846d30>
    p self.class  # Rabbit
  end
end

Rabbit.new.jump