require 'rails_helper'

RSpec.describe Group, type: :model do
  subject { FactoryBot.build(:group) }

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
      it { should belong_to(:owner).required }
      it { should belong_to(:created_by).required }
      it { should belong_to(:updated_by).required }
    end
  end
end
