require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid without email" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with duplicate email" do
      existing_user = create(:user)
      new_user = build(:user, email: existing_user.email)
      expect(new_user).not_to be_valid
    end

    it "is invalid with short password" do
      user.password = "12345"
      user.password_confirmation = "12345"
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it "has many materials" do
      expect(User.reflect_on_association(:materials).macro).to eq(:has_many)
    end
  end

  describe "#generate_jwt" do
    it "returns a JWT token" do
      user.save
      token = user.generate_jwt
      expect(token).to be_a(String)
      expect(token.split(".").length).to eq(3)
    end
  end
end