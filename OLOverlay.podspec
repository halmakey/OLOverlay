#
# Be sure to run `pod lib lint OLOverlay.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "OLOverlay"
  s.version          = "0.4.0"
  s.summary          = "Presents UIViewController like UIAlertView."
  s.description      = "This library provides a category for UIViewController with support presention UIViewController like UIAlertView with custom animation."
  s.homepage         = "https://github.com/halmakey/OLOverlay"
  s.license          = 'MIT'
  s.author           = { "halmakey" => "halmakey@cubicplus.net" }
  s.source           = { :git => "https://github.com/halmakey/OLOverlay.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

end
