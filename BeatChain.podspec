Pod::Spec.new do |s|
  s.name         = "BeatChain"
  s.version      = "1.0.0"
  s.summary      = "BeatChain is a password manager for iOS devices written in swift."
  s.description  = <<-DESC
                      BeatChain is a password manager for iOS devices, you can add, retrieve and delete
                      items from keychain.
                   DESC

  s.homepage           = "https://github.com/taxibeat/BeatChain"
  s.license            = { :type => "Apache Licence, Version 2.0", :file => "LICENSE" }
  s.authors            = { "ΒΕΑΤ" => "iosteam@thebeat.co" }
  s.social_media_url   = "http://twitter.com/taxibeat"
  s.source             = { :git => "https://github.com/taxibeat/BeatChain.git", :tag => "#{s.version}" }
  s.platform           = :ios, '10.0'
  s.source_files       = ["BeatChain/**/*.swift", "BeatChain/BeatChain.h"]
  s.swift_version      = "4.2"
  s.swift_versions     = ['4.0', '4.2', '5.0']
end