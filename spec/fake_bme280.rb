class FakeBme280
  def all
    { t: temperature, p: pressure, h: humidity}
  end

  def temperature
    20.0 + Random.rand * 20.0
  end

  def pressure
    1000.0 + Random.rand * 50.0
  end

  def humidity
    Random.rand * 100.0
  end
end