class Product < ApplicationRecord
    has_one_attached :image

    # MEMO:管理者関連のバリデーションはここに記載

    # HP設定画面（導入後）

    # 管理画面＿新規登録
    # validates :name, presence:true
    validate :validate_name
    validate :validate_summary
    validate :validate_choices
    # validates :fast_shipping_flg, inclusion: { in: [0, 1] }
    # validates :sold_out_flg, inclusion: { in: [0, 1] }
    validate :validate_flags_combination


    # その他のモデル定義...
    
    # 管理画面＿商品一覧（導入後）
        
    # 管理画面＿編集・削除（導入後）
    
    # 管理画面＿問い合わせ先設定画面（導入後）
    private

    def validate_name
        return if name.present?
        errors.add(:base, "Name can't be blank.")
    end 

    def validate_summary
        return if summary.present?
        errors.add(:base, "Summary can't be blank.")
    end 

    def validate_choices

        # return if name.present?
        # errors.add(:base, "Name can't be blank.")
        return unless choices.present?

        begin
          choices_hash = JSON.parse(choices)
        rescue JSON::ParserError
            errors.add(:choices, 'JSONの形式が不正です')
          return
        end

        choices_hash.each_with_index do |el, index|
                if el['gram'].blank? && el['price'].blank?
                    errors.add(:choices, "#{index + 1}番目の要素のGramとPriceはどちらも入力してください。")
                  elsif el['gram'].blank?
                    errors.add(:choices, "#{index + 1}番目の要素のGramは必須です。")
                  elsif el['price'].blank?
                    errors.add(:choices, "#{index + 1}番目の要素のPriceは必須です。")
                end
        
        end
    end

    def validate_flags_combination
        if fast_shipping_flg == 1 && sold_out_flg == 1
          errors.add(:base, "You can't set both fast shipping and sold out at the same time.")
        end
    end

end
