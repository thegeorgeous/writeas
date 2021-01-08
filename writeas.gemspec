require_relative 'lib/writeas/version'

Gem::Specification.new do |spec|
  spec.name          = "writeas"
  spec.version       = Writeas::VERSION
  spec.authors       = ["George Thomas"]
  spec.email         = ["iamgeorgethomas@gmail.com"]

  spec.summary       = %q{A Ruby client for the Write.as API}
  spec.description   = %q{A Ruby client for the Write.as API}
  spec.homepage      = "https://github.com/thegeorgeous/writeas"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/thegeorgeous.com/writeas/"
  spec.metadata["changelog_uri"] = "https://github.com/thegeorgeous.com/writeas/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency 'faraday', '~> 1.3.0'
  spec.add_runtime_dependency 'faraday_middleware', '~> 1.0.0'
end
