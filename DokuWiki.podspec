Pod::Spec.new do |s|
  s.name         = "DokuWiki"
  s.version      = "0.2.0"
  s.summary      = "A DokuWiki XMLRPC Swift Interface"
  s.homepage     = "https://github.com/whoisronnoc/DokuWiki-Swift"

	s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "whoisronnoc" => "connor@ronnoc.info" }
  s.source       = { :git => "https://github.com/whoisronnoc/DokuWiki-Swift.git", :tag => "#{s.version}" }

	s.platform     = :ios, "11.0"
	s.dependency "SWXMLHash", "~> 4.7.0"
	s.source_files  = "DokuWiki/**/*.{swift}"

	s.swift_version = "4.2"
end
