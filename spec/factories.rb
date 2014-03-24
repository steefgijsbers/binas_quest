FactoryGirl.define do
  factory :user do
    naam      "Steef"
    email     "steef@example.com"
    klas      "5Hb"
    progress  "start"
    password  "foobar"
    password_confirmation "foobar"
  end
end