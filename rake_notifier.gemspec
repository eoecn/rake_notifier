Gem::Specification.new do |s|
  s.name        = "rake_notifier"
  s.version     = "0.1"
  s.date        = '2013-05-08'
  s.summary     = ""
  s.description = s.summary
  s.authors     = ["Oscar Del Ben", "David Chen"]
  s.email       = 'mvjome@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'http://github.com/mvj3/rake_notifier'
  s.licenses    = ["MIT"]

  s.add_dependency "rake"
  s.add_dependency "pony"
  s.add_dependency "only_one_rake"
end
