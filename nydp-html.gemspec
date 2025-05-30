lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nydp/html/version'

Gem::Specification.new do |spec|
  spec.name          = "nydp-html"
  spec.version       = Nydp::Html::VERSION
  spec.authors       = ["Conan Dalton"]
  spec.email         = ["conan@conandalton.net"]
  spec.summary       = %q{nydp interface for HAML and Textile}
  spec.description   = %q{provides 'render-as-haml and 'render-as-textile functions}
  spec.homepage      = "http://github.com/conanite/nydp-html"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake",    "~> 13"

  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rspec_numbering_formatter'

  spec.add_dependency             'nydp',    '>= 0.5.1'
  spec.add_dependency             'haml',    '>= 4'
  spec.add_dependency             'RedCloth'
end
