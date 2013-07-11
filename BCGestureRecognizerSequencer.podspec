Pod::Spec.new do |s|
  s.name         = "BCGestureRecognizerSequencer"
  s.version      = "1.0"
  s.summary      = "A simple way to detect sequence of gestures"
  s.homepage     = "https://github.com/Ciechan/BCGestureRecognizerSequencer"
  s.license      = 'MIT'
  s.author       = { "Bartosz Ciechanowski" => "ciechan@gmail.com" }
  s.source       = { :git => "https://github.com/Ciechan/BCGestureRecognizerSequencer.git", :tag => "1.0" }
  s.platform     = :ios
  s.source_files = 'BCGestureRecognizerSequencer.{h,m}'
  s.requires_arc = true
  
  s.ios.deployment_target = '5.0'
end
