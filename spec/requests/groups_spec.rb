require 'rails_helper'

RSpec.describe "/groups", type: :request do
  let(:user) { create(:user) }

  let(:valid_attributes) {
    { code: "everyone", sort_code: "a", owner_id: user.id, created_by_id: user.id, updated_by_id: user.id }
  }

  let(:invalid_attributes) {
    { code: "", owner_id: user.id, created_by_id: user.id, updated_by_id: user.id }
  }

  before { sign_in user }

  describe "GET /index" do
    it "renders a successful response" do
      Group.create! valid_attributes
      get groups_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      group = Group.create! valid_attributes
      get group_url(group)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_group_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      group = Group.create! valid_attributes
      get edit_group_url(group)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Group" do
        expect {
          post groups_url, params: { group: valid_attributes }
        }.to change(Group, :count).by(1)
      end

      it "redirects to the created group" do
        post groups_url, params: { group: valid_attributes }
        expect(response).to redirect_to(group_url(Group.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Group" do
        expect {
          post groups_url, params: { group: invalid_attributes }
        }.to change(Group, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post groups_url, params: { group: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { code: "everyone-updated" }
      }

      it "updates the requested group" do
        group = Group.create! valid_attributes
        patch group_url(group), params: { group: new_attributes }
        group.reload
        expect(group.code).to eq("everyone-updated")
      end

      it "redirects to the group" do
        group = Group.create! valid_attributes
        patch group_url(group), params: { group: new_attributes }
        group.reload
        expect(response).to redirect_to(group_url(group))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        group = Group.create! valid_attributes
        patch group_url(group), params: { group: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested group" do
      group = Group.create! valid_attributes
      expect {
        delete group_url(group)
      }.to change(Group, :count).by(-1)
    end

    it "redirects to the groups list" do
      group = Group.create! valid_attributes
      delete group_url(group)
      expect(response).to redirect_to(groups_url)
    end
  end
end
