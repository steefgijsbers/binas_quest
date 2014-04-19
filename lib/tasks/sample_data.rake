namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(naam: "Example User",
                 klas: "5Hb",
                 email: "example@railstutorial.org",
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
  end
end