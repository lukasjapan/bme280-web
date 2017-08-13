RSpec.describe BME280Web do
  def app
    BME280Web
  end

  before do
    Timecop.freeze
    (0..60).select(&:even?).each do |m|
      TphData.create(t: 0.0, p: 0.0, h: 0.0, timestamp: m.minutes.ago)
    end
  end

  after do
    Timecop.return
  end

  shared_examples :json_integrity do
    it 'should be a json response' do
      get url
      expect(last_response.header['Content-type']).to include('json')
    end

    it 'should be valid json' do
      get url
      expect{JSON.parse(last_response.body)}.not_to raise_error
    end
  end

  shared_examples :json_error do
    it 'produces a client error' do
      get url
      expect(last_response).to be_client_error
    end

    it 'has error content as string' do
      get url
      expect(JSON.parse(last_response.body)).to be_a(String)
    end
  end

  shared_examples :valid_tph_data do
    it 'has records should have ts,t,p,h data' do
      expect(subject).to all have_key('ts')
      expect(subject).to all have_key('t')
      expect(subject).to all have_key('p')
      expect(subject).to all have_key('h')
    end

    it 'has t,p,h data with valid types' do
      expect(subject.map { |d| d['ts'] }).to all be_a(Integer)
      expect(subject.map { |d| d['t'] }).to all be_a(Float)
      expect(subject.map { |d| d['p'] }).to all be_a(Float)
      expect(subject.map { |d| d['h'] }).to all be_a(Float)
    end
  end

  describe '/' do
    let(:url) { '/' }

    it 'should return status code 200' do
      get url
      expect(last_response).to be_ok
    end
  end

  describe '/latest.json' do
    let(:url) { '/latest.json' }

    subject do
      get url
      JSON.parse(last_response.body)
    end

    include_examples :json_integrity
    include_examples :valid_tph_data

    it 'has 3 records because of a default timespan of 5 min' do
      expect(subject.size).to eq(3)
    end

    context 'timespan of 15 min' do
      let(:url) { '/latest.json?s=900' }

      include_examples :json_integrity
      include_examples :valid_tph_data

      it 'has 8 records' do
        expect(subject.size).to eq(8)
      end
    end
  end

  describe '/range.json' do
    let(:from) { 45.minutes.ago.iso8601 }
    let(:to) { 5.minutes.ago.iso8601 }
    let(:url) { '/range.json?' + { from: from, to: to }.to_query }

    subject do
      get url
      JSON.parse(last_response.body)
    end

    include_examples :json_integrity
    include_examples :valid_tph_data

    it 'has 20 records' do
      expect(subject.size).to eq(20)
    end

    context 'empty input' do
      let(:url) { "/range.json" }

      include_examples :json_integrity
      include_examples :json_error
    end

    context 'bad input' do
      let(:to) { 'bad input' }

      include_examples :json_integrity
      include_examples :json_error
    end
  end
end
