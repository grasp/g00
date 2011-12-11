# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ancestry}
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stefan Kroes"]
  s.date = %q{2010-10-28}
  s.description = %q{Organise ActiveRecord model into a tree structure}
  s.email = %q{s.a.kroes@gmail.com}
  s.files = ["ancestry.gemspec", "init.rb", "install.rb", "lib/ancestry.rb", "lib/ancestry/has_ancestry.rb", "lib/ancestry/exceptions.rb", "lib/ancestry/class_methods.rb", "lib/ancestry/instance_methods.rb", "MIT-LICENSE", "README.rdoc"]
  s.homepage = %q{http://github.com/stefankroes/ancestry}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ancestry allows the records of a ActiveRecord model to be organised in a tree structure, using a single, intuitively formatted database column. It exposes all the standard tree structure relations (ancestors, parent, root, children, siblings, descendants) and all of them can be fetched in a single sql query. Additional features are named_scopes, integrity checking, integrity restoration, arrangement of (sub)tree into hashes and different strategies for dealing with orphaned records.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.2.2"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.2.2"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.2.2"])
  end
end
