require 'rails_helper'

RSpec.describe "Dogs", type: :request  do
  describe "GET /dogs" do
    before do
        sign_in_as_a_valid_user
    end

    it "works! (now write some real specs)" do
      get admin_dogs_path
      expect(response).to have_http_status(200)
    end
  end
end
