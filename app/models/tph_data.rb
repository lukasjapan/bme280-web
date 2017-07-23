class TphData < ApplicationRecord
  def self.create_from_bme280(bme280)
    create(bme280.all) do |d|
      d.timestamp = DateTime.now
    end
  end
end
