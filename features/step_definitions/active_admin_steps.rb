def path_to(page_name)
  case page_name
    when 'the dashboard'
      admin_root_path
  end
end

def ensure_user_created(email)
  user = AdminUser.where(email: email).first_or_create(password: 'password', password_confirmation: 'password')

  unless user.persisted?
    raise "Could not create user #{email}: #{user.errors.full_messages}"
  end
  user
  end

When /^I fill in the password field with "([^"]*)"$/ do |password|
  fill_in 'admin_user_password', with: password
end

Given /^an admin user "([^"]*)" exists$/ do |email|
  ensure_user_created(email)
end

When /^(?:I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

When /^(?:I )press "([^"]*)"$/ do |button|
  click_button(button)
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  expect(URI.parse(current_url).path).to eq path_to page_name
end

Then /^(?:I )should( not)? see( the element)? "([^"]*)"$/ do |negate, is_css, text|
  should = negate ? :not_to        : :to
  have   = is_css ? have_css(text) : have_content(text)
  expect(page).send should, have
end