require 'rails_helper'

RSpec.describe "groups/index", type: :view do
  let(:user) { create(:user) }

  before(:each) do
    assign(:groups, [
      Group.create!(code: "group-1", owner_id: user.id, created_by_id: user.id, updated_by_id: user.id),
      Group.create!(code: "group-2", owner_id: user.id, created_by_id: user.id, updated_by_id: user.id)
    ])
  end

  it "renders a list of groups" do
    render
    cell_selector = 'div>p'
  end
end
