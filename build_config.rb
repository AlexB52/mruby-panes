MRuby::Build.new do |conf|
  toolchain :gcc

  conf.cc.defines << 'MRB_UTF8_STRING'

  conf.gem github: 'iij/mruby-mtest'
  conf.gem "#{ MRUBY_ROOT }/.."
  conf.gembox 'default'

  conf.cc.flags << '-g -O0 -fsanitize=address'
  conf.linker.flags << '-fsanitize=address'

  conf.enable_debug
  conf.enable_bintest
  conf.enable_test
end
