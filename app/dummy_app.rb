# frozen_string_literal: true

require_relative '../system/boot'

class DummyApp
  def self.run
    LOGGER.info('Run dummy test')
  end
end
