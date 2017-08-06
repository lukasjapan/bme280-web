require 'active_record'

class TphData < ActiveRecord::Base
  def self.create_from_bme280(bme280)
    create(bme280.all) do |d|
      d.timestamp = DateTime.now
    end
  end

  def to_json
    {
        ts: timestamp.to_i,
        t: t.round(2),
        p: p.round(2),
        h: h.round(2)
    }.to_json
  end
end
