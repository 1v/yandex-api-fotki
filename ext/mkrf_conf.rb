require 'rubygems/dependency_installer'

di = Gem::DependencyInstaller.new

begin
  if RUBY_VERSION < "2.2.2"
    di.install "activesupport", "< 5"
  else
    di.install "activesupport", ">= 4.0.0"
  end
rescue => e
  exit!
end
# Write fake Rakefile for rake since Makefile isn't used
File.open(File.join(File.dirname(__FILE__), 'Rakefile'), 'w') do |f|
  f.write("task :default" + $/)
end
