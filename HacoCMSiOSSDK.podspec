Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "HacoCMSiOSSDK"
s.summary = "hacoCMS SDK for iOS"
s.description  = <<-EOS
hacoCMSのiOS用 API クライアントライブラリです。
EOS
s.requires_arc = true

s.version = "1.0.0"
s.license = { :type => "MIT", :file => "License.md" }

s.author = { "Seesaa Inc." => "g-hacocms@seesaa.co.jp" }
s.homepage = "https://hacocms.com/"

s.source = { :git => "https://github.com/hacocms/hacocms-ios-sdk.git",
             :tag => "#{s.version}" }

s.source_files = "HacoCMSiOSSDK/Sources/**/*.swift"

s.dependency 'Alamofire', '~> 5.6.2'
s.dependency 'Moya', '~> 15.0.0'
s.dependency 'ReactiveSwift', '~> 6.7.0'
s.dependency 'RxSwift', '~> 6.5.0'

s.swift_version = "5.0"

end
