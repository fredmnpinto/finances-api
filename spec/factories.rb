FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }

    groups { build_list :group, 1 }
  end

  factory :group do
    name { Faker::Book.title }
  end

  factory :expense do
    amount { Faker::Number.decimal(l_digits: 2) }
    title { Faker::Commerce.product_name }
    currency { Faker::Base.rand(4).to_i }

    association :group
  end
end
