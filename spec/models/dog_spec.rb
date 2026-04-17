require 'rails_helper'

RSpec.describe Dog, type: :model do
  it "is valid with factory attributes" do
    expect(build(:dog)).to be_valid
  end

  it "persists custom name and age values" do
    dog = create(:dog, name: "Thor", age: 4)

    expect(dog.reload.name).to eq("Thor")
    expect(dog.age).to eq(4)
  end
end
