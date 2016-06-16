include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :partner_product_type do
    title_ru       { generate :string } 
    subtitle_ru    { generate :string }
    description_ru { generate :text }
    picture        { fixture_file_upload('test/fixtures/rails.png', 'image/png') }
  end
end

