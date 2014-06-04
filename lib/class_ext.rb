class String
  def clear_url
    _self = self
    if self.end_with?("/")
      _self = self.chop
    end
    _self.gsub("http://", "")
  end

  def with_color(color)
    ["<span style='color:#{color};word-break:break-all'>", self, "</span>"].join('').html_safe
  end

  def color_block(color, bgcolor)
    ["<span style='padding: 3px; font-size:9pt; background-color:#{bgcolor}; color:#{color};'>", self, "</span>"].join('').html_safe
  end

  def red
    with_color("red")
  end

  def blue
    with_color("blue")
  end

  def bold
    ["<span style='font-weight:bold;'>", self, "</span>"].join
  end

  def md5
    require "md5"
    MD5.hexdigest(self)
  end

  def icc_encode
    #Base64.encode64(self).gsub('+', '!').gsub('/', '*').gsub('=', '-').gsub('X', '__').chop
    Base64.encode64(self).gsub('+', '!').gsub('/', '*').gsub('=', '__').gsub('M', '-').chop
  end

  def icc_decode
    #Base64.decode64(self.gsub('!', '+').gsub('*', '/').gsub('-', '=').gsub('__', 'X'))
    Base64.decode64(self.gsub('!', '+').gsub('*', '/').gsub('__', '=').gsub('-', 'M'))
  end

  # p 代表小数点
  # v 随机添加无用字符
  def num_encode
    ku = %w(b c e f g h i j k l m n o q r s t u x w)
    odd_flag = 'a'
    even_flag = 'z'
    nums = %w(0 1 2 3 4 5 6 7 8 9)

    result = ''
    if self.first.to_i%2==0
      result += even_flag
    else
      result += odd_flag
      ku = ku.reverse
    end

    self.each_char do |n|
      unless nums.include?(n)
        result+='p'
        next
      end
      result+=ku[n.to_i]
    end
    result
  end

  def num_decode
    source_str = self
    ku = %w(b c e f g h i j k l m n o q r s t u x w)
    odd_flag = 'a'
    even_flag = 'z'

    ku.reverse! if odd_flag==source_str.first
    source_str=source_str[1..100]
    result = ''
    source_str.each_char do |n|
      if n=='p'
        result += '.'
        next
      end
      result += ku.index(n).to_s
    end
    result
  end
end

class Float

  #n 要保留的小数位数，flag=1 四舍五入 flag=0 不四舍五入
  def rounda(n, flag=1)
    y = 10.0 ** n
    if flag==1
      (self*y).round/y
    else
      (self*y).floor/y
    end
  end
end

class Time
  def label
    self.strftime("%Y-%m-%d %H:%M:%S")
  end

  def next_work_day(days = 1)
    start_date = self
    (1..(days*2)).each do
      start_date += 1.day
      unless [0, 6].include?(start_date.wday)
        days = days -1
      end
      break if days<=0
    end
    return start_date
  end

  def last_work_day(days = 1)
    start_date = self
    (1..(days*2)).each do
      start_date -= 1.day
      unless [0, 6].include?(start_date.wday)
        days = days - 1
      end
      break if days<=0
    end
    return start_date
  end

  def self.last_day_of_month(month, year = Time.now.year)
    mdays = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    mdays[2] = 29 if Date.leap?(year)
    last_day = mdays[month]
    Time.mktime(year, month, last_day)
  end

  def first_day_of_the_same_month
    Time.parse("#{self.year}-#{self.month}-01")
  end

  def last_day_of_the_same_month
    Time.last_day_of_month(self.month, self.year)
  end

  def format_date(type)
    case type
      when :full
        self.strftime("%Y-%m-%d %H:%M:%S")
      when :min
        self.strftime("%Y-%m-%d %H:%M")
      when :date
        self.strftime("%Y-%m-%d")
      when :year
        self.strftime("%Y")
      when :quarter
        [self.strftime("%Y"), "年", [["第一", "第二", "第三", "第四"][(self.month-1)/3], "季度"]].join
    end
  end
end

class Array

  def array_sum
    _sum = 0.0
    self.each { |a| _sum+=a.to_f }
    return _sum
  end

  def array_average
    self.array_sum / self.size
  end

  def perm(n)
    if size < n or n < 0
    elsif n == 0
      yield([])
    else
      self[1..-1].perm(n - 1) do |x|
        (0...n).each do |i|
          yield(x[0...i] + [first] + x[i..-1])
        end
      end
      self[1..-1].perm(n) do |x|
        yield(x)
      end
    end
  end

  def comb(n)
    c = []
    self.perm(n) do |a|
      b = a.sort
      c << b unless c.include?(b)
    end
    c.each { |a| yield(a) }
  end

  def delete_once(v)
    self.each_with_index do |e, i|
      if e==v
        self[i] = nil
        break
      end
    end
    self.compact!
  end
end