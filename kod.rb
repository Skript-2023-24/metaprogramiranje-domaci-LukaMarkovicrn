require "google_drive"

class Tabelica
    include Enumerable

    attr_accessor :spreadsheet_id, :worksheet, :worksheet_number, :headers
  
    def initialize(spreadsheet_id, worksheet_number)
      @spreadsheet_id = spreadsheet_id
      @worksheet_number = worksheet_number
      @worksheet = autentikacija
      @headers = worksheet.rows[0]
    end

    def autentikacija
        session = GoogleDrive::Session.from_config("config.json")
        session.spreadsheet_by_key("1P16n5kgtnzSt2X60xvvwqnyR8RhnDog1jcuH4Yl9OvU").worksheets[worksheet_number]
    end

    

    def red(red_broj)
        puts "red #{red_broj}: #{
            worksheet.rows[red_broj]
            }"
    end

    def [](header)
        header_index = headers.index(header)
      
        return nil unless header_index
      
        kolona = worksheet.rows[1..-1].map { |red| red[header_index] }
        Kolona.new(kolona, worksheet, header_index)
    end

    def method_missing(method_name, *args)
        modified_string = method_name.to_s.gsub(/\b\w/, &:capitalize)
        header_index = headers.index(modified_string)

        return nil unless header_index
        
        kolona = worksheet.rows[1..-1].map { |red| red[header_index] }
        Kolona.new(kolona, worksheet, header_index)
    end

    def each(&_block)
        worksheet.rows[1..-1].each do |red|
            red_str = red.join(", ")
            yield(red_str)
        end
    end

    def print
        puts "Headers: #{headers}"

        worksheet.rows[1..-1].each do |red|
            puts "red: #{red}"
        end
    end
end

class Kolona
    include Enumerable

    attr_accessor :kolona, :worksheet, :header_index

    def initialize(kolona, worksheet, header_index)
      @kolona = kolona
      @worksheet = worksheet
      @header_index = header_index
    end
  
    def [](index)
        kolona[index - 1]
    end
  
    def []=(index, value)
      worksheet[index + 1, header_index + 1] = value
      kolona[index + 1] = value

      ponovo_ucitaj_kolonu
    end


    def method_missing(method_name, *args)
        red_index = kolona.index(method_name.to_s)

        return nil unless red_index

        worksheet.rows[red_index + 1]
    end

    def to_s
        kolona.map(&:to_s).join(' ')
    end

    def map(&_block)
        br_kolone = kolona.map(&:to_i)
        br_kolone.map do |red|
            yield(red)
        end
    end

    def select(&_block)
        br_kolone = kolona.map(&:to_i)
        br_kolone.select do |red|
            yield(red)
        end
    end

    def reduce(n = nil, &_block)
        br_kolone = kolona.map(&:to_i)
        br_kolone.reduce do |n, red|
            yield(n, red)
        end
    end

    def sum
        br_kolone = kolona.map(&:to_i)
        br_kolone.compact.sum
    end

    def avg
        br_kolone = kolona.map(&:to_i)
        values = br_kolone.compact
        values.empty? ? nil : values.sum / values.length.to_f
    end
  
    private
  
    def ponovo_ucitaj_kolonu
        kolona = worksheet.rows[1..-1].map { |red| red[header_index] }
    end
end