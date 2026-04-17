require "rails_helper"

RSpec.describe SidebarHelper, type: :helper do
  describe "#menu_active?" do
    let(:current_menu) { { url: { controller: "dogs" } } }

    before do
      allow(helper).to receive(:controller_name).and_return("dogs")
    end

    it "returns true when current controller matches menu controller" do
      expect(helper.menu_active?(current_menu)).to be(true)
    end

    it "returns active string when text mode is enabled" do
      expect(helper.menu_active?(current_menu, true)).to eq("active")
    end

    it "returns nil when menu does not match current controller" do
      expect(helper.menu_active?({ url: { controller: "users" } })).to be_nil
    end
  end

  describe "#mobile_navbar_title" do
    it "returns active menu name when available" do
      helper.instance_variable_set(:@menu, [ { active: true, name: "Cachorros" } ])

      expect(helper.mobile_navbar_title).to eq("Cachorros")
    end

    it "returns translated title when no active menu name is available" do
      helper.instance_variable_set(:@menu, [])
      allow(helper).to receive(:controller_name).and_return("dogs")
      allow(helper).to receive(:t).with("dogs.plural", default: "").and_return("Dogs")

      expect(helper.mobile_navbar_title).to eq("Dogs")
    end

    it "falls back to humanized controller name when translation is blank" do
      helper.instance_variable_set(:@menu, [])
      allow(helper).to receive(:controller_name).and_return("admin_users")
      allow(helper).to receive(:t).with("admin_users.plural", default: "").and_return("")

      expect(helper.mobile_navbar_title).to eq("Admin users")
    end
  end
end
