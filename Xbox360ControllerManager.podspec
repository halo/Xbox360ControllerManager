Pod::Spec.new do |s|
  s.name         = "Xbox360ControllerManager"
  s.version      = "0.0.1"
  s.summary      = ""
  s.author       = 'halo'
  s.homepage     = "http://github.com/halo/Xbox360ControllerManager"
  s.license      = { :type => 'MIT', :file => 'MIT-LICENSE' }
  s.source       = { :git => "https://github.com/halo/Xbox360ControllerManager.git", :tag => s.version.to_s }
  s.source_files = 'Classes'
  s.requires_arc = true
  s.platform     = :osx
  s.framework   = 'IOKit'
end
