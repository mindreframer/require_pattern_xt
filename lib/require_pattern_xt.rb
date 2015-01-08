require "require_pattern_xt/version"
require 'require_pattern_xt/coloring'
require 'require_pattern_xt/core'

module Kernel
  def require_pattern(*patterns)
    RequirePatternXt::Core.require_pattern(patterns)
  end

  # this has to be in kernel module, so we keep the caller_locations intact
  def require_relative_pattern(*patterns)
    caller_path = caller_locations(1,1)[0].path
    patterns.map! { |pattern| File.join(File.dirname(caller_path), pattern) }
    require_pattern(*patterns)
  end
end
