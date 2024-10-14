# frozen_string_literal: true

require 'rake'

desc 'Load complete environment into rake process'
task :environment do
  require_relative 'config/boot'
end

# Import external rake tasks
Dir.glob('lib/tasks/*.rake').each { |r| import r }
