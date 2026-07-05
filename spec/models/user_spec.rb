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

    context "ownership" do
      # owner_id/created_by_id/updated_by_id presence can't be exercised via
      # validate_presence_of: self_reference_ownership (before_validation)
      # refills any blank one of the three as soon as id is known, which is
      # always the case here. The DB NOT NULL constraint is the real backstop;
      # what we can actually guarantee and test is the self-reference itself.
      it "self-references owner/created_by/updated_by when none are given" do
        user = User.new(
          code: "self_ref_test",
          email: "self_ref_test@example.com",
          password: "Password123!",
          password_confirmation: "Password123!"
        )
        user.valid?

        expect(user.owner_id).to eq(user.id)
        expect(user.created_by_id).to eq(user.id)
        expect(user.updated_by_id).to eq(user.id)
      end
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
