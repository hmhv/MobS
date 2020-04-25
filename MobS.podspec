Pod::Spec.new do |s|
  s.name = 'MobS'
  s.version = '0.0.1'
  s.summary = 'MobS is a reactive library inspired by MobX written in Swift.'
  s.description = 'MobS is a reactive library inspired by MobX written in Swift.'
  s.license = { type: 'MIT', file: 'LICENSE' }
  s.homepage = 'https://github.com/hmhv/MobS'
  s.social_media_url = 'https://hmhv.info'
  s.authors = { 'hmhv' => 'admin@hmhv.info' }

  s.swift_version = '5.1'

  s.ios.deployment_target = '10.0'
  s.ios.framework  = 'Foundation'

  s.source = { :git => 'https://github.com/hmhv/MobS.git', :tag => s.version }
  s.source_files = 'Sources/MobS/**/*.swift'

end
