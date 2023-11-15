# frozen_string_literal: true

class CoolumOperation

  include Enumerable

  def initialize(table, *colums)
    @table = table
    @colums = colums.flatten
  end


  def sum
    @colums.inject() do |sum, num|
      sum.to_i + num.to_i
    end
  end

  def avg
    @colums.inject() { |sum, num| sum.to_i + num.to_i } / @colums.size.to_f
  end

  def each(&block)
    @colums.each(&block)
    self #return the original array
  end

  def map(&block)
    result = []
    self.each do |element|
      result << block.call(element)
    end
    return result
  end

  def select(&block)
    result =[]
    self.each do |element|
      result << element if block.call(element) == true
    end
    result
  end

  def reduce(&block)
    result = 0
    self.each do |element|
      result += block.call(element)
    end
    return result
  end

  def method_missing(value)

    ind = 0

    @table.rows.each_with_index do |row, index|
      row.each{|col| col.to_s.eql?(value.to_s) ? ind = index : next }
    end

    return lookTotalAndSub(@table.rows[ind.to_i]) == 1 ? "POSTOJI REC TOTAL ILI SUBTOTAL" : @table.rows[ind.to_i]

  end

  def lookTotalAndSub(row)

    check = 0

    (0...row.length).each do |col|
      row[col]=~/total/ || row[col]=~/subtotal/ ? check = 1 : next
    end

    return check.to_i

  end

  def to_s
    return @colums.to_s
  end

end

