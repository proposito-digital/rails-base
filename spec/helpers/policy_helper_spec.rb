require "rails_helper"

RSpec.describe PolicyHelper, type: :helper do
  describe "#check_policy_to_button" do
    let(:user) { create(:user) }

    it "returns enabled button metadata when there is no policy error" do
      allow(helper).to receive(:check_policy_error).with(instance: user, action: :show?).and_return(false)

      css_class, properties, policy_error = helper.check_policy_to_button(user, :show?, [], "/admin/users/1", "Show")

      expect(css_class).to eq("class='btn-icon'")
      expect(properties).to include("title='Show'")
      expect(policy_error).to eq(false)
    end

    it "returns disabled button metadata when policy error exists on context instance" do
      context_user = create(:user)
      allow(helper).to receive(:check_policy_error).with(instance: user, action: :destroy?).and_return(false)
      allow(helper).to receive(:check_policy_error).with(instance: context_user, action: :destroy?).and_return("Not allowed")

      css_class, properties, policy_error = helper.check_policy_to_button(user, :destroy?, [], "/admin/users/1", "Delete", context_user)

      expect(css_class).to eq("class='btn-icon disabled'")
      expect(properties).to include("title='Not allowed'")
      expect(policy_error).to eq("Not allowed")
    end

    it "skips policy checks when instance or action is missing" do
      css_class, properties, policy_error = helper.check_policy_to_button(nil, nil, [], "/admin/users/1", "Show")

      expect(css_class).to eq("class='btn-icon'")
      expect(properties).to include("title='Show'")
      expect(policy_error).to eq(false)
    end
  end

  describe "#check_policy" do
    let(:user) { create(:user) }

    it "returns policy result when authorization method does not raise" do
      allow(helper).to receive(:policy).with(user).and_return(double(update?: true))

      expect(helper.check_policy(instance: user, action: :update?)).to be(true)
    end

    it "returns false when Pundit raises not authorized error" do
      policy_error = Pundit::NotAuthorizedError.new(query: :update?, record: user, policy: UserPolicy.new(true, user))
      allow(helper).to receive(:policy).with(user).and_raise(policy_error)

      expect(helper.check_policy(instance: user, action: :update?)).to be(false)
    end
  end

  describe "#check_policy_error" do
    let(:user) { create(:user) }
    let(:dog) { create(:dog) }

    it "returns false when policy allows action" do
      allow(helper).to receive(:policy).with(user).and_return(double(update?: true))

      expect(helper.check_policy_error(instance: user, action: :update?)).to be(false)
    end

    it "returns translated message when policy returns false" do
      allow(helper).to receive(:policy).with(user).and_return(double(update?: false))
      allow(helper).to receive(:t).with("user_policy.update?", scope: "pundit", default: :default).and_return("Cannot update")

      expect(helper.check_policy_error(instance: user, action: :update?)).to eq("Cannot update")
    end

    it "returns translated message from raised Pundit error policy and query" do
      policy_error = Pundit::NotAuthorizedError.new(query: :destroy?, record: dog, policy: DogPolicy.new(true, dog))
      allow(helper).to receive(:policy).with(dog).and_raise(policy_error)
      allow(helper).to receive(:t).with("dog_policy.destroy?", scope: "pundit", default: :default).and_return("Cannot destroy")

      expect(helper.check_policy_error(instance: dog, action: :destroy?)).to eq("Cannot destroy")
    end
  end
end
