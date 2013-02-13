# -*- coding: utf-8 -*-

require 'date'

module JapanesePhoneNumber
  module Era
    def era_to_date(era)
      if era =~ /平成(\d+)年(\d+)月(\d+)日/
        era_year = $1.to_i
        year = era_year + 1988
        month = $2.to_i
        day = $3.to_i

        Date.new(year, month, day)
      else
        raise ArgumentError, "unsupported format: #{era}"
      end
    end
  end
end