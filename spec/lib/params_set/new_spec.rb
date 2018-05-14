context 'initialize params set with valid attributes' do
  let(:options) do
    {
      title: {type: :string},
      amount: {type: :number},
      'created_at' => {'type' => 'date', default_value: {from: '09.11.2016', to: '17.11.2017'}},
      kind: {
        type: 'list',
        values: {red: 1, 'green' => '2', red_and_green: [1, 2]},
        default_value: [1,2]
      },
      status: {
        type: :list,
        values: [:confirm, 'unconfirm'],
        default_value: :unconfirm
      },
      confirmed: {type: :boolean, default_value: false},
      sort: {
        type: :sorting,
        values: [:id, :title, :amount],
        default_value: 'id_desc'
      }
    }
  end

  subject { SampleFilter::ParamsSet.new(options) }

  it 'should return fields list' do
    expect(subject.fields).to match_array([:title, :amount, :created_at, :kind, :status, :confirmed, :sort])
  end

  it 'shoud initialize new params set object' do
    expect(subject).to be_a(SampleFilter::ParamsSet)
    expect(subject.title).to be_nil
    expect(subject.amount).to be_nil
    expect(subject.created_at).to eq({from: '09.11.2016', to: '17.11.2017'})
    expect(subject.kind).to eq('[1, 2]')
    expect(subject.status).to eq('unconfirm')
    expect(subject.confirmed).to eq('f')
    expect(subject.sort).to eq('id_desc')
  end

  it 'should return default value' do
    expect(subject.type_of(:title)).to eq(:string)
    expect(subject.type_of(:amount)).to eq(:number)
    expect(subject.type_of(:created_at)).to eq(:date)
    expect(subject.type_of(:kind)).to eq(:list)
    expect(subject.type_of(:status)).to eq(:list)
    expect(subject.type_of(:confirmed)).to eq(:boolean)
    expect(subject.type_of(:sort)).to eq(:sorting)
  end

  it 'should return values' do
    expect(subject.values_for('created_at')).to be_nil
    expect(subject.values_for(:kind)).to eq({'red' => 1, 'green' => '2', 'red_and_green' => [1, 2]})
    expect(subject.values_for(:status)).to eq(['confirm', 'unconfirm'])
    expect(subject.values_for(:sort)).to eq(['id', 'title', 'amount'])
  end
end

context 'initialize invalid params set' do
  subject { SampleFilter::ParamsSet.new(params) }

  context 'without params' do
    let(:params) { {title: {}} }
    it { expect{ subject }.to raise_error(ArgumentError, 'title type error') }
  end

  context 'without type param' do
    let(:params) { {title: {type: 'invalid'}} }
    it { expect{ subject }.to raise_error(ArgumentError, 'title type error') }
  end

  context 'without correct values for list' do
    let(:params1) { {enum: {type: 'list'}} }
    let(:params2) { {enum: {type: 'list', values: []}} }
    let(:params3) { {enum: {type: 'list', values: {}}} }
    let(:params4) { {enum: {type: 'list', values: 'string'}} }

    it { expect{ SampleFilter::ParamsSet.new(params1) }.to raise_error(ArgumentError, 'enum values error') }
    it { expect{ SampleFilter::ParamsSet.new(params2) }.to raise_error(ArgumentError, 'enum values error') }
    it { expect{ SampleFilter::ParamsSet.new(params3) }.to raise_error(ArgumentError, 'enum values error') }
    it { expect{ SampleFilter::ParamsSet.new(params4) }.to raise_error(ArgumentError, 'enum values error') }
  end

  context 'without correct values for sorting' do
    let(:params1) { {sort: {type: 'sorting'}} }
    let(:params2) { {sort: {type: 'sorting', values: []}} }
    let(:params3) { {sort: {type: 'sorting', values: {test: :one}}} }
    let(:params4) { {sort: {type: 'sorting', values: 'string'}} }

    it { expect{ SampleFilter::ParamsSet.new(params1) }.to raise_error(ArgumentError, 'sort values error') }
    it { expect{ SampleFilter::ParamsSet.new(params2) }.to raise_error(ArgumentError, 'sort values error') }
    it { expect{ SampleFilter::ParamsSet.new(params3) }.to raise_error(ArgumentError, 'sort values error') }
    it { expect{ SampleFilter::ParamsSet.new(params4) }.to raise_error(ArgumentError, 'sort values error') }
  end
end
