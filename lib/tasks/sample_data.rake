namespace :db do
  desc "Fill database with sample data"
  
  task populate: :environment do
    User.create!(naam: "Steef",
                 klas: "5Hb",
                 email: "steef_gijsbers@hotmail.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    99.times do |n|
      naam  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      klas  = "5Hb"
      password  = "password"
      User.create!(naam: naam,
                   email: email,
                   klas: klas,
                   password: password,
                   password_confirmation: password)
    end
    99.times do |n|
      name  = "Level #{n+1}"
      img_src = "#{n+1}.bmp"
      solution = "he"      
      Level.create!(name: name,
                    img_src: img_src,
                    solution: solution)
    end
  end
end