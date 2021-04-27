require 'rerackt/ui'

module Rerackt
  module_function

  def root
    @root ||= Pathname(__dir__).expand_path
  end
end
