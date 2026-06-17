require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user, password: "Password123!") }

  it "authenticates the user" do
    post session_path, params: {
      email: user.email,
      password: "Password123!"
    }

    expect(response).to redirect_to(dashboard_path)
  end
end