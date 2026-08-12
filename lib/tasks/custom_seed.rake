# frozen_string_literal: true

# lib/tasks/custom_seed.rake
namespace :db do
  namespace :seed do
    Dir[File.join(Rails.root, "db", "seeds", "*.rb")].each do |filename|
      task_name = File.basename(filename, ".rb").intern
      task task_name => :environment do
        load(filename) if File.exist?(filename)
        puts "seeding - #{filename}. for reals, yo!"
      end
    end
  end
end
