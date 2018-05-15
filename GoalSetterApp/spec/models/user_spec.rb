require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of(:username)}
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:session_token)}
  it { should validate_presence_of(:password_digest)}

  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:email) }


  it { should have_many(:comments) }
  it { should have_many(:goals) }

  subject(:bob) {User.create(username: 'BobTheBuilder', email: 'bob@bob.com', password: 'password')}
  describe "#password=" do
    it "assigns password_digest to user" do
      expect(bob.password_digest).not_to be(nil)
    end
  end

  describe "#is_password?" do
    it "should return true with correct password" do
      password = 'password'
      expect(bob.is_password?(password)).to eq(true)
    end
  end

  describe "#reset_session_token!" do
    it "should change user's session_token" do
      bob.ensure_session_token
      current_session_token = bob.session_token
      expect(bob.reset_session_token!).not_to eq(current_session_token)
    end
  end

  describe "#ensure_session_token" do
    it "should make sure user has a session token" do
      bob.ensure_session_token
      expect(bob.session_token).not_to be(nil)
    end
  end

  describe "::find_by_credentials" do
    context "with valid username and password" do
      it "should find user based on correct user name and password" do
        expect(User.find_by_credentials(bob.username,"password")).to eq(bob)
      end

      context "with invalid username and password" do
        it "should return nil if incorrect username or password" do
          expect(User.find_by_credentials(bob.username,"wrongpassword")).to be(nil)
        end
      end
    end
  end
end
