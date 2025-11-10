MRuby::Build.new do |conf|
  toolchain :gcc

  conf.cc.defines << 'MRB_UTF8_STRING'

  conf.gembox 'default'

  conf.gem github: 'iij/mruby-mtest'
  conf.gem github: 'alexb52/mruby-termbox2', branch: 'main'
  conf.gem "#{ MRUBY_ROOT }/.."


  conf.cc.flags << '-g -O0 -fsanitize=address'
  conf.linker.flags << '-fsanitize=address'

  conf.enable_debug
  conf.enable_bintest
  conf.enable_test
end
