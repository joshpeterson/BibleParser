require 'rake/testtask'

task default: %i[formatting test]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

desc 'Check code formatting'
task :formatting do
  sh 'bundle exec rbprettier -c .'
end
