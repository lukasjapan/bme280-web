RSpec.describe TphData do
  let(:bme280) { FakeBme280.new }

  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  describe 'create_from_bme280' do
    subject { described_class.create_from_bme280(bme280) }

    it 'should create a record' do
      expect{subject}.to change{described_class.count}.from(0).to(1)
    end

    it 'should have the timestamp set to now' do
      expect(subject.timestamp).to eq(DateTime.now)
    end
  end

  describe 'to_json' do
    let(:timestamp) { DateTime.now }
    let(:t) { 12.34567 }
    let(:p) { 23.34568 }
    let(:h) { 34.56789 }

    before do
      described_class.create(timestamp: timestamp, t: t, p: p, h: h)
    end

    let(:subject_hash) { JSON.parse(subject) }

    subject { described_class.first.to_json }

    it 'should be a json string' do
      expect(subject).to be_a(String)
      expect{JSON.parse(subject)}.not_to raise_error
    end

    it 'has the timestamp as integer' do
      expect(subject_hash['ts']).to eq(timestamp.to_i)
    end

    it 'has rounded t,p,h data' do
      expect(subject_hash['t']).to eq(t.round(2))
      expect(subject_hash['p']).to eq(p.round(2))
      expect(subject_hash['h']).to eq(h.round(2))
    end
  end
end
