require 'rake'

Gem::Specification.new do |s|
  s.name     = 'boston-street-scraper'
  s.version  = '0.0.3'
  s.platform = Gem::Platform::RUBY
  s.authors  = ['Ken Mazaika']
  s.email    = ['kenmazaika@gmail.com']
  s.summary  = 'Screen Scrape Boston Street Cleaning Data'
  s.files    = FileList['[A-Z]*', 'test/**/*', 'lib/**/*.*']
  s.require_paths = ['lib']

  s.add_dependency 'httparty'
  s.add_dependency 'nokogiri'
end
