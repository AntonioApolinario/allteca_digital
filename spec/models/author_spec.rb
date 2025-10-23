require "rails_helper"

RSpec.describe Author, type: :model do
  describe "validations" do
    it "is invalid without type" do
      author = Author.new(name: "Test")
      expect(author.valid?).to be false
    end

    it "is invalid without name" do
      author = Author.new(type: "Person")
      expect(author.valid?).to be false
    end
  end

  describe "Person" do
    it "is valid with valid attributes" do
      person = build(:person)
      expect(person.valid?).to be true
    end

    it "is invalid without birth_date" do
      person = Person.new(name: "Test Person")
      expect(person.valid?).to be false
      expect(person.errors[:birth_date]).to include("can't be blank")
    end

    it "has Person type" do
      person = build(:person)
      expect(person.type).to eq("Person")
    end
  end

  describe "Institution" do
    it "is valid with valid attributes" do
      institution = build(:institution)
      expect(institution.valid?).to be true
    end

    it "is invalid without city" do
      institution = Institution.new(name: "Test Institution")
      expect(institution.valid?).to be false
      expect(institution.errors[:city]).to include("can't be blank")
    end

    it "has Institution type" do
      institution = build(:institution)
      expect(institution.type).to eq("Institution")
    end
  end
end
