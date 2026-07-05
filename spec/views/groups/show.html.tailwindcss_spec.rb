require 'rails_helper'

RSpec.describe "groups/show", type: :view do
  let(:user) { create(:user) }

  before(:each) do
    assign(:group, Group.create!(code: "group-1", owner_id: user.id, created_by_id: user.id, updated_by_id: user.id))
  end

  it "renders attributes in <p>" do
    render
  end
end
