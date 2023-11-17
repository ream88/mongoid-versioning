$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

MODELS = File.join(File.dirname(__FILE__), 'app/models')
$LOAD_PATH.unshift(MODELS)

require 'mongoid'
require 'rspec'

require 'mongoid/versioning'

# These environment variables can be set if wanting to test against a database
# that is not on the local machine.
ENV['MONGOID_SPEC_HOST'] ||= 'localhost'
ENV['MONGOID_SPEC_PORT'] ||= '27017'

# These are used when creating any connection in the test suite.
HOST = ENV['MONGOID_SPEC_HOST']
PORT = ENV['MONGOID_SPEC_PORT'].to_i

# Mongoid.logger.level = Logger::DEBUG
Mongo::Logger.logger.level = Logger::WARN if defined?(Mongo)
# Mongo::Monitoring::CommandLogSubscriber::LOG_STRING_LIMIT = 10_000

# When testing locally we use the database named mongoid_test. However when
# tests are running in parallel on Travis we need to use different database
# names for each process running since we do not have transactions and want a
# clean slate before each spec run.
def database_id
  'mongoid_test'
end

def database_id_alt
  'mongoid_test_alt'
end

# Can we connect to MongoHQ from this box?
def mongohq_connectable?
  ENV['MONGOHQ_REPL_PASS'].present?
end

# Set the database that the spec suite connects to.
Mongoid.configure do |config|
  config.connect_to(database_id)
end

# Autoload every model for the test suite that sits in spec/app/models.
Dir[File.join(MODELS, '*.rb')].sort.each do |file|
  name = File.basename(file, '.rb')
  autoload name.camelize.to_sym, name
end

module Rails
  class Application
  end

  def self.logger; nil; end
end

module MyApp
  class Application < Rails::Application
  end
end

RSpec.configure do |config|
  # Drop all collections before each spec.
  config.before(:each) do
    Mongoid.purge!
  end

  # On travis we are creating many different databases on each test run. We
  # drop the database after the suite.
  config.after(:suite) do
    if ENV['CI']
      if defined?(Mongo)
        Mongo::Client.new(["#{HOST}:#{PORT}"], database: database_id).database.drop
        Mongo::Client.new(["#{HOST}:#{PORT}"], database: database_id_alt).database.drop
      else
        Mongoid::Threaded.sessions[:default].drop
      end
    end
  end

  # Filter out MongoHQ specs if we can't connect to it.
  config.filter_run_excluding(config: lambda do |value|
    return true if value == :mongohq && !mongohq_connectable?
  end)
end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular('address_components', 'address_component')
end
