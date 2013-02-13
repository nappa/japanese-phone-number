# -*- coding: utf-8 -*-

require 'japanese-phone-number/xls_importer'

class TestXlsImporter < Test::Unit::TestCase

  # 平成25年2月1日現在のデータから抜粋
  DATA = {
      :operator =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・電気通信事業者の事業者識別番号（００ＸＹ、００２ＹＺまたは００９１Ｎ１Ｎ２）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は００Ｘ、００２Ｙまたは００９１Ｎ１を、１行目の０～９は００ＸＹのＹコード、", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["００２ＹＺまたは００９１N１Ｎ２のＮ２コードを示します。（００１を除く）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["○００ＸＹ及び００２ＹＺ", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["00", "-", "ＫＤＤＩ", "-", "-", "-", "-", "-", "-", "-", "-"],
           ["003", "ＺＩＰ　Ｔｅｌｅｃｏｍ", "アイ・ピー・エス", "アイ・ピー・エス", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴ東日本", "フュージョンコミュニケーションズ", "フュージョンコミュニケーションズ", "ＮＴＴ西日本"],
           ["004", nil, "ソフトバンクテレコム", "ソフトバンクテレコム", "ソフトバンクテレコム", "ソフトバンクテレコム", "ソフトバンクテレコム", "ソフトバンクモバイル", nil, nil, nil]],
      :ip =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・ＩＰ電話の番号（０５０－ＣＤＥＦ－××××）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０５０－CDＥＦのＥコードまでを、１行目の０～９はＦコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["050100", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ"],
           ["050101", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ"],
           ["050102", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ"],
           ["050103", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ"],
           ["050104", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ"],
           ["050105", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ", "ソフトバンクＢＢ"]],
      :cellular_070 =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・携帯電話の番号（０７０－ＣＤＥ－ＦＧＨＪＫ）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["※電話番号から契約している携帯電話会社を調べることはできますか？", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０７０－CDコードを、１行目の０～９はＥコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["07010", "ドコモ", "ドコモ", "ドコモ", "ドコモ", nil, nil, nil, nil, nil, nil],
           ["07011", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["07012", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["07013", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]],
      :cellular_080 =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・携帯電話の番号（０８０－ＣＤＥ－ＦＧＨＪＫ）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["※電話番号から契約している携帯電話会社を調べることはできますか？", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０８０－CDコードを、１行目の０～９はＥコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["08010", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ"],
           ["08011", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ"],
           ["08012", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ"],
           ["08013", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ"]],
      :cellular_090 =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・携帯電話の番号（０９０－ＣＤＥ－ＦＧＨＪＫ）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["※電話番号から契約している携帯電話会社を調べることはできますか？", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０９０－CDコードを、１行目の０～９はＥコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["09010", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ", "ドコモ"],
           ["09011", "ＫＤＤＩ", "ドコモ", "ドコモ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ"],
           ["09012", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ", "ＫＤＤＩ"],
           ["09013", "ソフトバンクモバイル", "ソフトバンクモバイル", "ソフトバンクモバイル", "ソフトバンクモバイル", "ソフトバンクモバイル", "ソフトバンクモバイル", "ソフトバンクモバイル", "ソフトバンクモバイル", "ソフトバンクモバイル", "ソフトバンクモバイル"]],
      :phs =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・ＰＨＳの番号（０７０－ＣＤＥ－ＦＧＨＪＫ）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０７０－CDコードを、１行目の０～９はＥコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["07050", nil, "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム"],
           ["07051", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム"],
           ["07052", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム"],
           ["07053", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム"],
           ["07054", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム"],
           ["07055", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム", "ウィルコム"]],
      :pager =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・発信者課金ポケベル電話番号（０２０－ＣＤＥ－ＦＧＨＪＫ）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０２０－CDコードを、１行目の０～９はＥコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["02040", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["02041", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["02042", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["02043", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["02044", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["02045", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]],
      :tollfree_0120 =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・着信課金用電話番号（０１２０－ＤＥＦ－×××）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０１２０－DＥＦのＥコードまでを、１行目の０～９はＦコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["012000", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["012001", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["012002", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["012003", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["012004", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["012005", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"]],
      :tollfree_0800 =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・着信課金用電話番号（０８００－ＤＥＦ－××××）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０８００－DＥＦのＥコードまでを、１行目の０～９はＦコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["080000", "ＮＴＴコミュニケーションズ", nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["080001", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["080002", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["080003", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["080004", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["080005", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]],
      :navidial =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・統一番号（０５７０－ＤＥF－×××）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０５７０－ＤＥＦコードのＥコードまでを、１行目の０～９はＦコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["057000", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["057001", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["057002", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["057003", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["057004", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"],
           ["057005", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ", "ＮＴＴコミュニケーションズ"]],
      :premium_rate =>
          [[nil, nil, nil, nil, nil, nil, nil, nil, "電気通信番号指定状況", nil, nil],
           ["・情報料代理徴収機能用電話番号（０９９０－ＤＥＦ－×××）", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           [nil, nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)", nil, nil],
           ["表の\"番号\"列の部分は０９９０－DＥＦのＤＥコードを、１行目の０～９はＦコードを示します。", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["番号", "０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
           ["099000", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["099001", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["099002", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["099003", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["099004", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
           ["099005", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]],
      :local => [[nil, nil, nil, nil, nil, nil, nil, "(平成25年2月1日現在)"],
                 ["番号区画コード", "MA", "番号", "市外局番", "市内局番", "指定事業者", "使用状況", "備考"],
                 ["001", "札幌", "011200", "011", "200", "ＮＴＴ東日本", "使用中", nil],
                 ["001", "札幌", "011201", "011", "201", "ＮＴＴ東日本", "使用中", nil],
                 ["001", "札幌", "011202", "011", "202", "ＮＴＴ東日本", "使用中", nil],
                 ["001", "札幌", "011203", "011", "203", "ＮＴＴ東日本", "使用中", nil],
                 ["001", "札幌", "011204", "011", "204", "ＮＴＴ東日本", "使用中", nil],
                 ["001", "札幌", "011205", "011", "205", "ＮＴＴ東日本", "使用中", nil],
                 ["001", "札幌", "011206", "011", "206", "ＮＴＴ東日本", "使用中", nil],
                 ["001", "札幌", "011207", "011", "207", "ＮＴＴ東日本", "使用中", nil],
                 ["001", "札幌", "011208", "011", "208", "ＮＴＴ東日本", "使用中", nil]],
  }

  def setup
    @importer = JapanesePhoneNumber::XlsImporter.new
  end
  def test_import_local
    result = @importer.import_local(DATA[:local])
    assert(result.include?({:prefix=>"011200", :operator=>"ＮＴＴ東日本", :ma=>"札幌", :status=>:assigned, :etc=>nil, :type=>:local}))
  end
  def test_import_tollfree
    result = @importer.import_tollfree(DATA[:tollfree_0120])
    assert(result.include?({:operator=>"ＮＴＴコミュニケーションズ", :prefix=>"0120000", :type=>:tollfree}))
    result = @importer.import_tollfree(DATA[:tollfree_0800])
    assert(result.include?({:operator=>"ＮＴＴコミュニケーションズ", :prefix=>"0800000", :type=>:tollfree}))
  end
  def test_import_navidial
    result = @importer.import_navidial(DATA[:navidial])
    assert(result.include?({:operator=>"ＮＴＴコミュニケーションズ", :prefix=>"0570000", :type=>:navidial}))
  end
  def test_import_phs
    result = @importer.import_phs(DATA[:phs])
    assert(result.include?({:operator=>"ウィルコム", :prefix=>"070501", :type=>:phs}))
  end
  def test_import_cellular
    result = @importer.import_cellular(DATA[:cellular_070])
    result = @importer.import_cellular(DATA[:cellular_080])
    result = @importer.import_cellular(DATA[:cellular_090])
    assert(result.include?({:operator=>"ドコモ", :prefix=>"090100", :type=>:cellular}))
  end
  def test_import_operator
    result = @importer.import_operator(DATA[:operator])
    assert(result.include?({:operator=>"ＫＤＤＩ", :prefix=>"001", :type=>:operator}))
    assert(result.include?({:operator=>"ＮＴＴコミュニケーションズ", :prefix=>"0033", :type=>:operator}))
  end
  def test_import_premium_rate
    result = @importer.import_premium_rate(DATA[:premium_rate])
    assert(result.empty?())
  end
  def test_import_pager
    result = @importer.import_pager(DATA[:pager])
    assert(result.empty?())
  end
  def test_ip
    result = @importer.import_ip(DATA[:ip])
    assert(result.include?({:operator=>"ソフトバンクＢＢ", :prefix=>"0501000", :type=>:ip}))
  end
end