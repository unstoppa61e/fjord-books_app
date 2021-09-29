module LoginSupport
  def sign_in_as(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('input[type=submit]').click
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
