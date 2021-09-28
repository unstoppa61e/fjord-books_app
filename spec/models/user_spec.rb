# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do # rubocop:disable Metrics/BlockLength
  it 'is valid with an email address and a password' do
    user = FactoryBot.build_stubbed(:user)
    expect(user).to be_valid
  end

  it 'is invalid with a duplicate email address' do
    other_password = 'other@example.com'
    FactoryBot.create(:user, email: other_password)
    user = FactoryBot.build(:user, email: other_password)
    user.valid?
    expect(user.errors[:email]).to include(I18n.t('errors.messages.taken'))
  end

  it 'returns name when the user has a name' do
    user = FactoryBot.create(:user)
    expect(user.name_or_email).to eq(user.name)
  end

  it "returns email address when the user doesn't have a name" do
    user = FactoryBot.create(:user, name: nil)
    expect(user.name_or_email).to eq(user.email)
  end

  it 'creates an active relationship' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    user1.follow(user2)
    expect(Relationship.find_by(follower_id: user1.id).following_id).to eq(user2.id)
  end

  it 'destroys an active relationship' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    user1.follow(user2)
    expect(Relationship.find_by(follower_id: user1.id).following_id).to eq(user2.id)
    user1.unfollow(user2)
    expect(Relationship.find_by(follower_id: user1.id)).to eq(nil)
  end

  it 'returns true when the user is following the target user' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    user1.follow(user2)
    expect(user1.following?(user2)).to eq(true)
  end

  it 'returns false when the user is not following the target user' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    expect(user1.following?(user2)).to eq(false)
  end

  it 'returns true when the user is followed by the target user' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    user2.follow(user1)
    expect(user1.followed_by?(user2)).to eq(true)
  end

  it 'returns false when the user is not following the target user' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    expect(user1.followed_by?(user2)).to eq(false)
  end

  it 'can have many reports' do
    user = FactoryBot.create(:user, :with_reports)
    expect(user.reports.length).to eq 5
  end
end
