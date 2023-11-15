# frozen_string_literal: true

class Sintax

  def initialize(table, colums, index)
    @table = table
    @colums = colums
    @index = index
  end


  def [](value)
    return lookTotalAndSub(@table.rows[value.to_i - 1]) != 1 ? @colums[value.to_i - 1] : "REC TOTAL ILI SUB TOTAL PRONADJENA U REDU"
  end

  def []=(row, value)
    @table[row.to_i, @index + 1] = value
    @table.save
  end

  def to_s
    return @colums.to_s
  end

  def lookTotalAndSub(row)

    check = 0

    (0...row.length).each do |col|
      row[col]=~/total/ || row[col]=~/subtotal/ ? check = 1 : next
    end

    return check.to_i

  end

end
