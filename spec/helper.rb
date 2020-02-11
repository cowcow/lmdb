require 'lmdb'
require 'rspec'
require 'fileutils'

SPEC_ROOT = File.dirname(__FILE__)
TEMP_ROOT = File.join(SPEC_ROOT, 'tmp')

module LMDB::SpecHelper
  def mkpath(name = 'env')
    if( File.exist?('/dev/shm') )
      root = '/dev/shm/spec/lmdb'
    else
      root = TEMP_ROOT
    end
    @all_path ||= []
    @all_path << FileUtils.mkpath(File.join(root, name)).first
    @all_path.last
  end

  def rmpath
    FileUtils.rmtree( @all_path )
    @all_path.clear
  end

  def path
    @path ||= mkpath
  end

  def env
    @env ||= LMDB::Environment.new :path => path
  end
end

RSpec.configure do |c|
  c.include LMDB::SpecHelper
  c.after { FileUtils.rm_rf TEMP_ROOT }
  c.expect_with :rspec do |cc|
    cc.syntax = :should
  end
end
