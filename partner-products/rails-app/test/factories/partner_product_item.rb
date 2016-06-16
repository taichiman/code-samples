FactoryGirl.define do
  factory :partner_product_item do
    partner_product

    title_ru       { generate :string }
    tizer_ru       { generate :text }
    image          { fixture_file_upload('test/fixtures/rails.png', 'image/png') }
    description_ru { generate :text }
  end
end

