namespace :db do
  desc "Fill database with sample data"
  
  task populate: :environment do
    make_users
    make_levels
    make_levelpacks
    add_levels_to_levelpacks
  end
end    
    
def make_users    
  User.create!(naam: "Steef",
               klas: "5Hb",
               email: "steef_gijsbers@hotmail.com",
               password: "foobar",
               password_confirmation: "foobar",
               admin: true)
  50.times do |n|
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
  
def make_levels  
  60.times do |n|
    name  = "Level #{n+1}"
    img_src = "#{n+1}.bmp"
    solution = "he"      
    Level.create!(name: name,
                  img_src: img_src,
                  solution: solution)
  end
end
  
def make_levelpacks  
  60.times do |n|
    if n<10
      name = "levelpack_0#{n}"
    else
      name = "levelpack_#{n}"
    end
    title = "Mooie titel voor levelpack nummer #{n}"
    Levelpack.create(name: name, title: title, solution: "")
  end
end

def add_levels_to_levelpacks
  levelpacks = Levelpack.all[0..9]
  levels = Level.all[0..49]
  
  (0..9).each do |n|
    lvlpck = levelpacks[n]
    (0..4).each do |m|
      lvl = levels[5*n+m]
      lvlpck.add!(lvl)
      
    end
  end
end

