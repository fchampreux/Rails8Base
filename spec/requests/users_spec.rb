RSpec.describe "Users API", type: :request do
    describe "POST /users" do
      it "creates a user" do
        expect {
          post "/users", params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
  
        expect(response).to have_http_status(:created)
      end
    end
  end