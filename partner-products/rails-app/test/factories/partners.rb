FactoryGirl.define do
  factory :partner do
    name_ru { generate :string }
    description_ru { generate :string }
  end
end
