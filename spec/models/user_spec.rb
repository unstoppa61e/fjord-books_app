require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it 'is valid with an email address and a password' do
    user = User.new(
      email: "hoge@example.com",
      password: "password"
    )
    expect(user).to be_valid
  end

  it 'is invalid with a duplicate email address' do
    User.create(
      email: "hoge@example.com",
      password: "password"
    )
    user = User.new(
      email: "hoge@example.com",
      password: "password"
    )
    user.valid?
    expect(user.errors[:email]).to include(I18n.t('errors.messages.taken'))
  end
end
