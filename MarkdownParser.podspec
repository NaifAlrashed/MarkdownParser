#
# Be sure to run `pod lib lint MarkdownParser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MarkdownParser'
  s.version          = '0.1.0'
  s.summary          = 'A markdown parser written purely in swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A markdown parser written purely in swift. it can be used render markdown and display it in any format needed
                       DESC

  s.homepage         = 'https://github.com/NaifAlrashed/MarkdownParser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NaifAlrashed' => 'naifdev@gmail.com' }
  s.source           = { :git => 'https://github.com/NaifAlrashed/MarkdownParser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/**/*'
  
  # s.resource_bundles = {
  #   'MarkdownParser' => ['MarkdownParser/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
