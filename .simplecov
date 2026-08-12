SimpleCov.start 'rails' do
   add_filter "/lib/generators/rails/my_scaffold_controller/templates/"
   add_filter "/lib/generators/rails/my_scaffold_controller"
   add_filter "/lib/templates/rspec/"
   add_filter "/lib/templates/"
end
