require "rails_helper"

RSpec.describe Material, type: :model do
  let(:material) { build(:material) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(material).to be_valid
    end

    it "is invalid without title" do
      material.title = nil
      expect(material).not_to be_valid
    end

    it "is invalid without status" do
      material.status = nil
      expect(material).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to user" do
      expect(Material.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "belongs to author" do
      expect(Material.reflect_on_association(:author).macro).to eq(:belongs_to)
    end
  end
end