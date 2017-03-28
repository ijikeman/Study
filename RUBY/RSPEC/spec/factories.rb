FactoryGirl.define do
  factory :cat do
    name "Mike"
  end
  to_create { |instance| instance.save }
end
