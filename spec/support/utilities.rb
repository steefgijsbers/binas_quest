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
  level_1 = Level.create(name: "level1", img_src: "level1.bmp", solution: "he")
  level_1.generate_thumb_src
  level_2 = Level.create(name: "level2", img_src: "level2.bmp", solution: "he")
  level_2.generate_thumb_src
  levelpack = Levelpack.create(name: "levelpack_81", title: "Test levelpack")
  levelpack.add! level_1
  levelpack.add! level_2
  user.unlock! levelpack
end
