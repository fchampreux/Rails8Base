def full_title(page_title)
  base_title = "Open Data Quality"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in_via_form(login, password)
  visit new_user_session_path
  fill_in "Email or code", with: login
  fill_in "Password", with: password
  click_button "Sign in"
end
