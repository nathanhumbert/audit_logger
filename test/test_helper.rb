ENV['RAILS_ENV'] = 'test' 
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..' 
require 'test/unit' 

require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb')) 
require 'sqlite3'

def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
  ActiveRecord::Base.establish_connection()
  load(File.dirname(__FILE__) + "/schema.rb") 
  require File.dirname(__FILE__) + '/../init.rb' 
end

load_schema

def run_generator
  FileUtils.mkdir_p(fake_rails_root)
  FileUtils.mkdir_p(File.join(fake_rails_root, "app", "models"))
  silence_generator do
    Rails::Generator::Scripts::Generate.new.run(["audit_log", "AuditLog"], :destination => fake_rails_root)
  end
end

def silence_generator
  logger_original = Rails::Generator::Base.logger
  myout = StringIO.new
  Rails::Generator::Base.logger = Rails::Generator::SimpleLogger.new(myout)
  yield if block_given?
  Rails::Generator::Base.logger = logger_original
  myout.string
end


def cleanup_after_generator
  FileUtils.rm_r(fake_rails_root)
end


def fake_rails_root
  File.join(File.dirname(__FILE__), 'rails_root')
end

def model_file
  File.join(fake_rails_root, 'app', 'models', "audit_log_entry.rb") 
end

def migration_file_list
  Dir.glob(File.join(fake_rails_root, "db", "migrate", "*"))
end
