$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'

SimpleCov.start
# do
#   add_group 'Server', 'server'
#   add_group 'Client', 'client'
# end

SimpleCov.minimum_coverage 99
SimpleCov.refuse_coverage_drop
