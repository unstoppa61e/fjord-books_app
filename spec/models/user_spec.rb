# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do # rubocop:disable Metrics/BlockLength
  include_context 'setup'
  let(:user2) { FactoryBot.create(:user) }

  describe 'user validity' do
    context 'with an email address and a password' do
      it 'is valid' do
        user = FactoryBot.build_stubbed(:user)
        expect(user).to be_valid
      end
    end

    context 'without an email address' do
      it 'is invalid' do
        user = FactoryBot.build_stubbed(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include(I18n.t('errors.messages.blank'))
      end
    end

    context 'without a password' do
      it 'is invalid' do
        user = FactoryBot.build_stubbed(:user, password: nil)
        user.valid?
        expect(user.errors).to include(I18n.t('errors.messages.blank'))
      end
    end

    context 'with a duplicate email address' do
      it 'is invalid' do
        email = 'email@example.com'
        FactoryBot.create(:user, email: email)
        user = FactoryBot.build(:user, email: email)
        user.valid?
        expect(user.errors[:email]).to include(I18n.t('errors.messages.taken'))
      end
    end
  end

  it 'returns name when the user has a name' do
    expect(user.name_or_email).to eq(user.name)
  end

  it "returns email address when the user doesn't have a name" do
    user_no_name = FactoryBot.create(:user, name: nil)
    expect(user_no_name.name_or_email).to eq(user_no_name.email)
  end

  it 'creates an active relationship' do
    user.follow(user2)
    expect(Relationship.find_by(follower_id: user.id).following_id).to eq(user2.id)
  end

  it 'destroys an active relationship' do
    user.follow(user2)
    expect(Relationship.find_by(follower_id: user.id).following_id).to eq(user2.id)
    user.unfollow(user2)
    expect(Relationship.find_by(follower_id: user.id)).to eq(nil)
  end

  it 'returns true when the user is following the target user' do
    user.follow(user2)
    expect(user.following?(user2)).to eq(true)
  end

  it 'returns false when the user is not following the target user' do
    expect(user.following?(user2)).to eq(false)
  end

  it 'returns true when the user is followed by the target user' do
    user2.follow(user)
    expect(user.followed_by?(user2)).to eq(true)
  end

  it 'returns false when the user is not following the target user' do
    expect(user.followed_by?(user2)).to eq(false)
  end

  it 'can have many reports' do
    user3 = FactoryBot.create(:user, :with_reports)
    expect(user3.reports.length).to eq 5
  end
end
