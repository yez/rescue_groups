guard :rspec, cmd: 'rspec', notification: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^models/(.+)\.rb$})     { |m| "spec/models/#{m[1]}_spec.rb" }
  watch(%r{^search/(.+)\.rb$})     { |m| "spec/search/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
