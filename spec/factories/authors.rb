FactoryBot.define do
  factory :author do
    name { Faker::Name.name }
    
    factory :person do
      type { "Person" }
      birth_date { Faker::Date.birthday(min_age: 18, max_age: 80) }
    end
    
    factory :institution do
      type { "Institution" }
      name { Faker::Company.name }
      city { Faker::Address.city }
    end
  end
end
