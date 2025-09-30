# frozen_string_literal: true

class Admin::DogsController < Admin::BaseController
  private

  def default_params_permited
      [ :name, :age ]
  end

  def filter_fields
      [ "dogs.name", "dogs.age" ]
  end
end
