#
#  Be sure to run `pod spec lint Defactory.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "Defactory"
  s.version      = "0.1.0"
  s.summary      = "Objective-C object factory for your tests."

  s.description  = <<-DESC
                   Create test object, the right way.

                   * Define factories once, build everywhere.
                   * Named factories.
                   * Sequences.
                   * Associations.
                   * Handles primitives
                   * Factory inheritance.
                   * Tested.
                   DESC

  s.homepage     = "https://github.com/luisobo/Defactory"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Luis Solano" => "contact@luissolano.com" }

  s.ios.deployment_target = '4.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "https://github.com/luisobo/Defactory.git", :tag => "0.1" }
  s.source_files  = 'Defactory', 'Defactory/**/*.{h,m}'

  s.public_header_files = 'Defactory/**/*.h'

  s.requires_arc = true
end
