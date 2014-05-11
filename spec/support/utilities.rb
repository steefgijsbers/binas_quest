def full_title(page_title)
  base_title = "Binas Quest"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user, options={})
  if options[:no_capybara]
    #sign in when not using capybara
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
  else
    visit signin_path
    fill_in "Email",      with: user.email
    fill_in "Wachtwoord", with: user.password
    click_button "Log in"
  end
end

def setup_start_for(user)  
  (1..3).each do |n|
    levelpack = Levelpack.create(name: "levelpack_8#{n}", title: "Test levelpack #{n}")
    
    (1..2).each do |m|
      x = 2*(n-1)+m
      level = Level.create(name: "level#{x}", img_src: "level#{x}.bmp", solution: "he")
      level.generate_thumb_src
      levelpack.add! level
    end
    
    levelpack.update_solution
    user.unlock! levelpack
  end 
  levelpack = Levelpack.create(name: "levelpack_84", title: "Test levelpack 4")
  level7 = Level.create(name: "level7", img_src: "level7.bmp", solution: "he")
  level8 = Level.create(name: "level8", img_src: "level8.bmp", solution: "he")
  levelpack.add! level7
  levelpack.add! level8
  levelpack.update_solution
end
