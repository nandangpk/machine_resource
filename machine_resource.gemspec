
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "machine_resource/version"
require File.expand_path('../ext/machine_resource/memory.so', __FILE__)
require File.expand_path('../ext/machine_resource/cpu.so', __FILE__)


Gem::Specification.new do |spec|
  spec.name          = "machine_resource"
  spec.version       = MachineResource::VERSION
  spec.authors       = ["nandangpk"]
  spec.email         = ["nandangpermanakusuma@gmail.com"]
 
  spec.summary       = "A lightweight gem to monitor your hardware resource usage"
  spec.description       = "A lightweight gem to monitor your hardware resource usage"
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  #spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  #
  #  spec.metadata["homepage_uri"] = spec.homepage
  #  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against " \
  #    "public gem pushes."
  #end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  
  spec.files += Dir["ext/**/*"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 0.0.0"
  spec.add_dependency 'rails', '>= 1.0.0'
  spec.add_dependency 'ffi'
end
