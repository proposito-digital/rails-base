require 'rails_helper'

RSpec.describe "Users", type: :request  do
  describe "GET /users" do
  	before do
        sign_in_as_a_valid_user
    end
    
    it "works! (now write some real specs)" do
      get admin_users_path
      expect(response).to have_http_status(200)
    end
  end
end