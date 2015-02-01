# Provide basic require_relative support for 1.8.7 builds
unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative '../lib/sudotool'
require_relative '../lib/sudoerfile'
require_relative '../lib/sudoright'
require_relative '../lib/sudogroup'
require_relative '../lib/sudohostalias'
require_relative '../lib/sudocmdalias'
require_relative '../lib/sudoconvert'