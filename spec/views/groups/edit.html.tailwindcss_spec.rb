require 'rails_helper'

RSpec.describe "groups/edit", type: :view do
  let(:user) { create(:user) }

  let(:group) {
    Group.create!(code: "group-1", owner_id: user.id, created_by_id: user.id, updated_by_id: user.id)
  }

  before(:each) do
    assign(:group, group)
  end

  it "renders the edit group form" do
    render

    assert_select "form[action=?][method=?]", group_path(group), "post" do
    end
  end
end
