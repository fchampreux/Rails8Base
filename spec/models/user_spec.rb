RSpec.describe User, type: :model do
    subject { build(:user) }
  
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end