# -*- coding: utf-8 -*-

Bundler.setup(:default, :development)

require 'tempfile'
require 'csv'

require 'mechanize'
require 'roo'
require 'nokogiri'

module JapanesePhoneNumber
  class XlsImporter

    # 総務省 / 電気通信番号指定状況
    URL = 'http://www.soumu.go.jp/main_sosiki/joho_tsusin/top/tel_number/number_shitei.html'

    def initialize()
    end

    def scrape
      basedir = File.join(File.dirname(__FILE__), "..", "..", "tmp")
      unless File.directory?(basedir)
        Dir.mkdir(basedir)
      end

      files = []

      agent = Mechanize.new
      agent.get(URL)
      agent.page.links_with(href: /\.xls$/).each_with_index do |link, index|
        filename = File.join(basedir, File.basename(link.href))
        #f = File.open(filenae, "w")
        #f.write agent.get(link.href).body
        #f.close

        files << filename
      end

      files.each do |filepath|
        p filepath
        import(parse_xls(filepath))
      end
    end

    def parse_xls(path)
      xls = Roo::Excel.new(path)
      parse_csv(xls.to_csv)
    end

    def parse_csv(csv)
      CSV.parse(csv)[0..10]
    end

    def import(table)
      raise unless table.size > 4

      if table[1].find { |col| col =~ /^・情報料代理徴収機能用電話番号/ }
        import_premium_rate(table)
      elsif table[1].find { |col| col =~ /^・統一番号/ }
        import_navidial(table)
      elsif table[1].find { |col| col =~ /^・着信課金用電話番号（０８００/ }
        import_tollfree(table)
      elsif table[1].find { |col| col =~ /^・着信課金用電話番号（０１２０/ }
        import_tollfree(table)
      elsif table[1].find { |col| col =~ /^・発信者課金ポケベル電話番号/ }
        import_pager(table)
      elsif table[1].find { |col| col =~ /^・ＰＨＳの番号/ }
        import_phs(table)
      elsif table[1].find { |col| col =~ /^・携帯電話の番号/ }
        import_cellular(table)
      elsif table[1].find { |col| col =~ /^・ＩＰ電話の番号/ }
        import_ip(table)
      elsif table[1].find { |col| col =~ /^・電気通信事業者の事業者識別番号/ }
        import_operator(table)
      else
        import_local(table)
      end
    end

    MA = 1
    NumberPrefix = 2
    City = 3
    Town = 4
    Operator = 5
    Status = 6
    Etc = 7
    def import_local(table)
      puts "local"
      number_data = false

      result = []

      table.each do |row|
        if number_data == false
          # 番号表が出てくるまで飛ばす…
          if row == ["番号区画コード", "MA", "番号", "市外局番", "市内局番", "指定事業者", "使用状況", "備考"]
            number_data = true
          end
          next
        end

        status = nil
        case row[Status]
          when "未使用"
            status = :unassigned
          when "使用中"
            status = :assigned
          when "使用不可"
            status = :do_not_use
          else
            status = :unknown
        end

        result << {
            :prefix => row[NumberPrefix],
            :operator => row[Operator],
            :ma => row[MA],
            :status => status,
            :etc => row[Etc],
            :type => :local,
        }
      end

      result
    end

    def import_not_local(table, type)
      number_data = false

      result = []

      table.each do |row|
        if number_data == false
          # 番号表が出てくるまで飛ばす…
          if row == ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"]
            number_data = true
          end
          next
        end

        number_head = row[0]
        1.upto(11) do |col|
          number_suffix = col - 1
          if row[col].nil? || row[col].empty? || row[col] == "-"
            next
          end

          result << {
              :prefix => (number_head.to_s + number_suffix.to_s),
              :operator => row[col],
              :type => type,
          }
        end
      end

      result
    end

    def import_tollfree(table)
      type = :tollfree
      import_not_local(table, type)
    end

    def import_cellular(table)
      type = :cellular
      import_not_local(table, type)
    end
    def import_phs(table)
      type = :phs
      import_not_local(table, type)
    end
    def import_pager(table)
      type = :pager
      import_not_local(table, type)

    end
    def import_navidial(table)
      type = :navidial
      import_not_local(table, type)

    end
    def import_ip(table)
      type = :ip
      import_not_local(table, type)
    end
    def import_premium_rate(table)
      type = :premium_rate
      import_not_local(table, type)

    end
    def import_operator(table)
      type = :operator
      import_not_local(table, type)
    end
  end
end

if $0 == __FILE__
  x = JapanesePhoneNumber::XlsImporter.new
  x.scrape

end