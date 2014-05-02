namespace :db do
  desc "Fill database with sample data"
  
  task populate: :environment do
    make_users
    make_levels
    make_levelpacks
    add_levels_to_levelpacks
    add_first_levelpack_to_users
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
  12.times do |n|
    if n<9
      name = "levelpack_0#{n+1}"
    else
      name = "levelpack_#{n+1}"
    end
    title = "Mooie titel voor levelpack nummer #{n+1}"
    Levelpack.create!(name: name, title: title, solution: "")
  end
end

def add_levels_to_levelpacks
  levelpacks = Levelpack.all
  levels = Level.all
  
  (0..11).each do |n|
    lvlpck = levelpacks[n]
    (0..4).each do |m|
      lvl = levels[5*n+m]
      lvlpck.add!(lvl)      
    end
    update_solution_of lvlpck
  end
end

def update_solution_of(levelpack)
  solution = "" 
  levelpack.corresponding_levels.each do |lvl|
    solution += lvl.solution
  end
  levelpack.update_attribute(:solution, solution)
end

def add_first_levelpack_to_users
  users = User.all
  first_levelpack = Levelpack.find_by_name "levelpack_01"
  users.each do |user|
    user.unlock! first_levelpack
  end
end

