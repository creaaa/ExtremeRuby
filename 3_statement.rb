
# Exception
# SecurityError
# ScriptErrorとそのサブクラス
# NoMemoryError
# Interrupt
# SystemStackError

# は、 => e で捕捉できない。
# rescue Exception => e とかやったらできるが。

def otnk 
  # raise Exception, "unko"
end


result = begin
  value = "hoge!!"
  raise
rescue
  value  # 例外が発生し、ここが返る。
else
  value
end

p result
p value  # それどころか、ここからも見える。












