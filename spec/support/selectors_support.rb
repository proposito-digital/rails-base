# frozen_string_literal: true

module Selectors
  Capybara.add_selector(:linkhref) do
    xpath { |href| ".//a[@href='#{href}']" }
  end
  Capybara.add_selector(:data_original_title) do
  css { |v| "*[data-original-title='#{v}']" }
  end
end
