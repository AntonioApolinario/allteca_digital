FactoryBot.define do
  factory :material do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
    status { "rascunho" }
    association :user
    association :author
    type { "Book" }

    factory :book do
      type { "Book" }
      isbn { Faker::Number.unique.number(digits: 13).to_s }
      page_count { rand(100..500) }
    end
    
    factory :article do
      type { "Article" }
      doi { "10.1000/#{Faker::Alphanumeric.unique.alphanumeric(number: 6)}" }
    end
    
    factory :video do
      type { "Video" }
      duration_minutes { rand(5..120) }
    end
    
    trait :published do
      status { "publicado" }
    end
  end
end
