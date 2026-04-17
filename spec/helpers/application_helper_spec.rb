require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#instance_attributes_only" do
    it "filters attributes by the provided attribute names" do
      user = create(:user)

      expect(helper.instance_attributes_only(user, [ "email_address" ])).to eq(
        "email_address" => user.email_address
      )
    end
  end

  describe "#hours_options" do
    it "returns 96 quarter-hour options from 00:00 to 23:45" do
      options = helper.hours_options

      expect(options.size).to eq(96)
      expect(options.first).to eq("00:00")
      expect(options.last).to eq("23:45")
    end
  end

  describe "#present" do
    it "uses model-specific presenter when available" do
      model_class = Class.new
      presenter_class = Class.new do
        attr_reader :model, :view

        def initialize(model, view)
          @model = model
          @view = view
        end
      end

      stub_const("FancyModel", model_class)
      stub_const("FancyModelPresenter", presenter_class)

      presenter = helper.present(FancyModel.new)
      expect(presenter).to be_a(FancyModelPresenter)
    end

    it "falls back to ApplicationPresenter when model presenter is missing" do
      model_class = Class.new
      fallback_presenter = Class.new do
        attr_reader :model, :view

        def initialize(model, view)
          @model = model
          @view = view
        end
      end

      stub_const("NoPresenterModel", model_class)
      stub_const("ApplicationPresenter", fallback_presenter)

      presenter = helper.present(NoPresenterModel.new)
      expect(presenter).to be_a(ApplicationPresenter)
    end
  end

  describe "#flash_type" do
    it "maps alert to warning" do
      expect(helper.flash_type("alert")).to eq("warning")
    end

    it "maps error to danger" do
      expect(helper.flash_type("error")).to eq("danger")
    end

    it "maps danger to danger" do
      expect(helper.flash_type("danger")).to eq("danger")
    end

    it "maps notice to primary" do
      expect(helper.flash_type("notice")).to eq("primary")
    end

    it "returns empty string for unknown type" do
      expect(helper.flash_type("unknown")).to eq("")
    end
  end

  describe "#flash_banner_class" do
    it "returns warning class for alert" do
      expect(helper.flash_banner_class("alert")).to include("border-amber-200")
    end

    it "returns danger class for error" do
      expect(helper.flash_banner_class("error")).to include("border-red-200")
    end

    it "returns primary class for notice" do
      expect(helper.flash_banner_class("notice")).to include("border-blue-200")
    end

    it "returns default class for unknown type" do
      expect(helper.flash_banner_class("unknown")).to include("border-slate-200")
    end
  end

  describe "#markdown" do
    it "renders markdown HTML with configured options" do
      markdown_klass = Class.new do
        class << self
          attr_reader :last_options
        end

        def initialize(_text, *options)
          self.class.instance_variable_set(:@last_options, options)
        end

        def to_html
          "<p>Rendered</p>"
        end
      end

      stub_const("Markdown", markdown_klass)

      html = helper.markdown("**hello**")
      expect(html).to include("<p>Rendered</p>")
      expect(Markdown.last_options).to include(:hard_wrap, :no_images)
    end
  end
end
