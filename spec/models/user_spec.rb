# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do # rubocop:disable Metrics/BlockLength
  describe 'user validity' do
    context 'with an email address and a password' do
      it 'is valid' do
        user = FactoryBot.build_stubbed(:user)
        expect(user).to be_valid
      end
    end

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe '#name_or_email' do
    context 'the user has a name' do
      it 'returns name' do
        user = FactoryBot.create(:user)
        expect(user.name_or_email).to eq(user.name)
      end
    end

    context 'the user does not have a name' do
      it 'returns email address' do
        user_no_name = FactoryBot.create(:user, name: nil)
        expect(user_no_name.name_or_email).to eq(user_no_name.email)
      end
    end
  end

  describe '#follow' do
    it 'creates an active relationship' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      user1.follow(user2)
      expect(Relationship.find_by(follower_id: user1.id).following_id).to eq(user2.id)
    end
  end

  describe '#unfollow' do
    it 'destroys an active relationship' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      user1.follow(user2)
      expect(Relationship.find_by(follower_id: user1.id).following_id).to eq(user2.id)
      user1.unfollow(user2)
      expect(Relationship.find_by(follower_id: user1.id)).to eq(nil)
    end
  end

  describe '#following?' do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }

    context 'the user is following the target user' do
      it 'returns true' do
        user1.follow(user2)
        expect(user1.following?(user2)).to eq(true)
      end
    end

    context 'the user is not following the target user' do
      it 'returns false' do
        expect(user1.following?(user2)).to eq(false)
      end
    end
  end

  describe '#followed_by?' do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }

    context 'the user is followed by the target user' do
      it 'returns true' do
        user1.follow(user2)
        expect(user2.followed_by?(user1)).to eq(true)
      end
    end

    context 'the user is not followed by the target user' do
      it 'returns false' do
        expect(user2.followed_by?(user1)).to eq(false)
      end
    end
  end

  describe 'reports number' do
    it 'can have many reports' do
      user = FactoryBot.create(:user, :with_reports)
      expect(user.reports.length).to eq 5
    end
  end
end
