lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "message_bus_client_worker/version"

Gem::Specification.new do |spec|
  spec.name          = "message_bus_client_worker"
  spec.version       = MessageBusClientWorker::VERSION
  spec.authors       = ["Ramon Tayag"]
  spec.email         = ["ramon.tayag@gmail.com"]

  spec.summary       = %q{Subscribe to MessageBus using Sidekiq workers}
  spec.homepage      = "https://github.com/bloom-solutions/message_bus_client_worker"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gem_config"
  spec.add_dependency "sidekiq", ">= 5.1"
  spec.add_dependency "excon"
  spec.add_dependency "addressable"
  spec.add_dependency "light-service"
  spec.add_dependency "sidekiq-unique-jobs", ">= 6.0.0"
  spec.add_dependency "activesupport"
  spec.add_dependency "circuitbox", ">= 1.0"
  spec.add_dependency "http"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-sidekiq"
  spec.add_development_dependency "wait"
end
