require 'google_drive'
require 'C:\Users\Bolen\OneDrive\Desktop\untitled\sintax.rb'
require 'C:\Users\Bolen\OneDrive\Desktop\untitled\coolum_operation.rb'

class TableImplementation

  include Enumerable

  def initialize(session, num)
    @table = session.spreadsheet_by_key("1p5S3RwPA-xaFVx-r4jdSjQEl8TC5nY-_cxD6BYGndKg").worksheets[num]
    @colums = Hash.new
    @table.rows[0].each_with_index {|value, index| @colums[value.to_s.downcase.gsub(' ','')] = index }
  end

  def to_array
    @table.rows.map(&:to_a)
  end

  def each(&block)
    @table.rows.each do |row|
      row.each(&block)
    end
  end

  def row(value)
    return @table.rows[value.to_i - 1]
  end

  def [](kolona)
    kolone = []
    splitovanaKolona = kolona.split("\"")

    @table.rows.each do |row|
      kolone.append(row[@colums[splitovanaKolona[0].to_s.downcase.gsub(' ', '')].to_i])
    end

    Sintax.new(@table, kolone, @colums[splitovanaKolona[0].to_s.downcase.gsub(' ', '')].to_i)
  end


  def method_missing(colum)
    colums = []

    @table.rows.each do |row|
      if lookTotalAndSub(row) != 1
        row[@colums[colum.to_s.downcase.gsub(' ', '')].to_i]=~/[0-9]/ ? colums.append(row[@colums[colum.to_s.downcase.gsub(' ', '')].to_i].to_i) : next
      end
    end

    CoolumOperation.new(@table, colums)
  end

  def lookTotalAndSub(row)

    check = 0

    (0...row.length).each do |col|
      row[col]=~/total/ || row[col]=~/subtotal/ ? check = 1 : next
    end

    return check.to_i
  end

  def lookEmpty(row)

    check = 0

    (0...row.length).each{|col| row[col] == "" ? check+=1 : break}

    return check == row.length ? 1 : 0

  end
  
  def +(table2)
    if @table.rows[1].eql?(table2.getTable.rows[1])
      table2.getTable.rows.each_with_index do |row, index|
        index > 1? @table.insert_rows(@table.num_rows + 1, [row]) : next
        @table.save
      end
    end
  end

  def -(table2)

    arrDel = []

    @table.rows.each_with_index do |row, index|
      table2.getTable.rows.each do |row2|
        checkRow(row, row2) == 1 && index > 1 ? arrDel.append(index+1) : next
        break
      end
    end

    (0...arrDel.length).each do |index|
      @table.delete_rows(arrDel[index] - index, 1)
      @table.save
    end

  end

  def checkRow(row1, row2)

    check = 0

    (0...row1.length).each do|i|
      row1[i] == row2[i] ? check+=1 : break
    end

    return check == @table.num_cols ? 1 : 0
  end
  
  def getTable
    @table
  end

  def to_s
    @table.rows.each_with_index do | row, index |

      print "\n"

      if lookEmpty(row) == 1
        print "_______________prazan red___________________"
        next
      end

      row.each do |col|
        print col + " | "
      end

    end
  end
end

session = GoogleDrive::Session.from_config("config.json")

table = TableImplementation.new(session, 0)
table1 = TableImplementation.new(session, 1)



p table.to_array

p table.row(3)
p table.row(3)[2]

table.each do |cell|
  print cell + " "
end

puts table["Druga kolona"]
p table["Druga kolona"][3]
p table["Prva kolona"][3] = 1000

p table.trecakolona.sum
p table.trecakolona.avg

p table.indeks.rn2310

p table.prvakolona.map{ |cell| cell + 10 }
p table.prvakolona.select{|cell| cell.even? }


p table.indeks.rn111

table+table1
table-table1

table.to_s



