require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.build(:user) }

  describe "validations" do
    context "code" do
      it { should validate_presence_of(:code) }
      it { should validate_uniqueness_of(:code).case_insensitive }
      it { should validate_length_of(:code).is_at_most(64) }
    end

    context "uuid" do
      it { should validate_uniqueness_of(:uuid).ignoring_case_sensitivity }
    end

    context "email" do
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_length_of(:email).is_at_most(255) }

      it "rejects an invalid email format" do
        subject.email = "not-an-email"
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).not_to be_empty
      end
    end
  end
end
