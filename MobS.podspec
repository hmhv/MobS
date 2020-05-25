Pod::Spec.new do |s|
  s.name = 'MobS'
  s.version = '0.3.6'
  s.summary = 'Simple, safe state management for swift'
  s.description = 'MobS is a simple and safe state management library transparently applying functional reactive programming (TFRP) and is inspired by [MobX](https://mobx.js.org/).'
  s.license = { type: 'MIT', file: 'LICENSE' }
  s.homepage = 'https://github.com/hmhv/MobS'
  s.social_media_url = 'https://hmhv.info'
  s.authors = { 'hmhv' => 'admin@hmhv.info' }

  s.swift_version = '5.2'

  s.ios.deployment_target = '10.0'
  s.ios.framework  = 'Foundation'

  s.source = { :git => 'https://github.com/hmhv/MobS.git', :tag => s.version }
  s.source_files = 'Sources/MobS/**/*.swift'

end
