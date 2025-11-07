MRuby::Gem::Specification.new('mruby-panes') do |spec|
  spec.license  = 'MIT'
  spec.author   = 'Alexandre Barret'
  spec.description = 'mruby-pane wraps a native layout core inspired by Clay to compute flex, grid, and text layouts.'

  spec.rbfiles = %w[
    mrblib/modules/*.rb
    mrblib/*.rb
  ].flat_map do |pattern|
    Dir.glob(File.join(__dir__, pattern))
  end
end
