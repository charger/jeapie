if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'simplecov-rcov'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::RcovFormatter
  ]
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'fake_web'
require 'fakeweb_matcher'
require 'jeapie'

include Jeapie

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

FakeWeb.allow_net_connect = false