Pod::Spec.new do |s|
  s.name     = 'SDOrientationController'
  s.version  = '1.0'
  s.platform = :ios
  s.license  = 'MIT'
  s.summary  = 'Easily use different view controllers for portrait and landscape orientations.'
  s.homepage = 'https://github.com/StudioDalton/SDOrientationController'
  s.author   = { 'Douwe Maan' => 'douwe@selenight.nl' }
  s.source   = { :git => 'https://github.com/StudioDalton/SDOrientationController.git', :tag => 'v1.0' }
  
  s.description = %{
    SDOrientationController enables you to use different view controllers for portrait and landscape orientations. 
    It will automatically handle all rotations and transition between the portrait and landscape view controllers as appropriate. 
    This way you can easily build an app where one view controller is shown when the device is held in portrait orientation, and another when held in landscape orientation.
  }
  
  s.requires_arc = true
  s.source_files = 'Source'
  s.clean_paths  = 'Example'
end
