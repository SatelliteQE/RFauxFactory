
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rfauxfactory/version'

Gem::Specification.new do |spec|
  spec.name          = "rfauxfactory"
  spec.version       = RFauxFactory::VERSION
  spec.authors       = ['Og Maciel']
  spec.email         = ['omaciel@ogmaciel.com']
  spec.summary       = 'Generates random data for your tests.'
  spec.description   = 'Generates random data for your tests. Ruby port for https://github.com/omaciel/fauxfactory.'
  spec.homepage      = 'https://github.com/SatelliteQE/RFauxFactory'
  spec.license       = 'Apache 2.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
