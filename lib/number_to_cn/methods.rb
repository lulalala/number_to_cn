#encoding:utf-8
module NumberToCn 
  CN_T_TRANS           = [ "", "壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖", "拾" ]
  CN_T_TRANS_WITH_ZERO = [ "零", "壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖", "拾" ]
  CN_T_POSITION        = [ "", "拾", "佰", "仟" ]
  CN_T_BIG             = [ "", "萬", "億", "萬" ]

  def to_cn_words
    if self.class == Fixnum
      int_words
    elsif self.class == Float
      float_words
    end
  end

  def self.int_words(num)
    return "零" if num == 0

    num_arr = num.to_s.split('').reverse
    rst_arr = []

    writable = -1 
    #1： 都需要写；
    #0： 写一个零，后面的'千'不用写； 
    #-1：不需要写'千'，也不需要写'零'；

    num_arr.each_with_index do |value, index|
      writable = -1 if index%4 == 0
      cc = (index%4 == 0) ? CN_T_BIG[index/4] : ""
      aa = CN_T_TRANS[value.to_i]

      if value.to_i == 0
        bb = (writable == 1) ? "零" : ""
        writable = (writable == 1) ? 0 : -1
      else
        bb = CN_T_POSITION[index%4]
        writable = 1
      end

      rst_arr << aa + bb + cc
    end

    rst_arr.reverse.join
  end

  def int_words
    self.class.int_words(self)
  end

  def self.float_words(num)
    before_point     = num.to_i
    after_point      = num.to_s.split(".")[1]
    after_point_zero = "零" * (after_point.length - after_point.to_i.to_s.length)
    "#{before_point.int_words}点#{after_point_zero}#{after_point.to_i.to_cn_clearly}"
  end

  def float_words
    self.class.float_words(self)
  end
  
  def to_cn_clearly
    to_s.split('')
        .delete_if{ |c| c =~ /\D/ }
        .map{ |c| CN_T_TRANS_WITH_ZERO[c.to_i] }
        .join
  end
end
