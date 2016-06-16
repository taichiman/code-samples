FactoryGirl.define do
  factory :partner_product do
    partner
    partner_product_type

    title_ru       { generate :string }
    subtitle_ru    { generate :text   }
    description_ru { generate :string }
  end
end
