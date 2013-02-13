# -*- coding: utf-8 -*-
module JapanesePhoneNumber
  # 固定 (0AB-J)
  module Local
  end

  # 携帯 (070-CDE-FGHJK, 080-CDE-FGHJK, 090-CDE-FGHJK)
  module Cellular
  end

  # PHS (070-CDE-FGHJK)
  module PHS
  end

  # ポケベル (020-CDE-FGHJK)
  module Pager
  end

  # 情報料代理徴収 (0990-DEF-xxxx)
  module PremiumRate
  end

  # 統一番号 (0570-DEF-xxx), いわゆるナビダイヤル
  module NaviDial
  end

  # 着信者課金(0800-DEF-xxxx, 0120-DEF-xxxx)
  module TollFree
  end

  # IP電話 (050-CDEF-xxxx)
  module IP
  end

  # 事業者識別番号
  module Operator

  end
  # 不明
  module Unknown
  end
end
