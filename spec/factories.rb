FactoryGirl.define do
  factory :user do
    sequence(:naam)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    klas "5Hb"
    password "foobar"
    password_confirmation "foobar"
         
    factory :admin do
      admin true
    end
  end

  
  factory :level do
    name      "examplelevel"
    img_src   "examplelevel.jpg"
    thumb_src "examplelevel_thumb.jpg"
    solution  "he"
  end
  
  factory :levelpack do
    name      "levelpack_01"
    title     "example title"
    solution  ""
  end
end