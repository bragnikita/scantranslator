# Load the Rails application.
require_relative 'application'


app_environment_variables = File.join(Rails.root, 'shared', 'app_environment.rb')
load(app_environment_variables) if File.exists?(app_environment_variables)

# Initialize the Rails application.
Rails.application.initialize!

Scanlet::Project.create_test_struct 'Project_Main' if Scanlet::Project.find_by({:name => 'Project_Main'}).nil?
