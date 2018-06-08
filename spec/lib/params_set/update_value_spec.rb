context 'update values for params set field' do
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

  it 'should update values' do
    expect(subject.values_for(:kind)).to eq({'red' => 1, 'green' => '2', 'red_and_green' => [1, 2]})
    subject.update_value(:kind, {'blue' => 3, black: '4'})
    expect(subject.values_for(:kind)).to eq({'blue' => 3, 'black' => '4'})
  end

  it 'should update array' do
    expect(subject.values_for(:kind)).to eq({'red' => 1, 'green' => '2', 'red_and_green' => [1, 2]})
    subject.update_value('kind', [:confirm, 'unconfirm'])
    expect(subject.values_for(:kind)).to eq(['confirm', 'unconfirm'])
  end

  it 'should not update value' do
    expect(subject.values_for(:title)).to be_nil
    subject.update_value(:title, 'lalalala')
    expect(subject.values_for(:title)).to be_nil
  end

  it { expect{ subject.update_value(:blablabla, [:confirm, 'unconfirm']) }.to raise_error(ArgumentError, 'blablabla not found error') }
  it { expect{ subject.update_value(:kind, nil) }.to raise_error(ArgumentError, 'kind values error') }
  it { expect{ subject.update_value(:kind, {}) }.to raise_error(ArgumentError, 'kind values error') }
  it { expect{ subject.update_value(:kind, []) }.to raise_error(ArgumentError, 'kind values error') }
  it { expect{ subject.update_value(:kind, 'string') }.to raise_error(ArgumentError, 'kind values error') }

  it { expect{ subject.update_value(:status, nil) }.to raise_error(ArgumentError, 'status values error') }
  it { expect{ subject.update_value(:status, {}) }.to raise_error(ArgumentError, 'status values error') }
  it { expect{ subject.update_value(:status, []) }.to raise_error(ArgumentError, 'status values error') }
  it { expect{ subject.update_value(:status, 'string') }.to raise_error(ArgumentError, 'status values error') }

  it { expect{ subject.update_value(:sort, nil) }.to raise_error(ArgumentError, 'sort values error') }
  it { expect{ subject.update_value(:sort, {}) }.to raise_error(ArgumentError, 'sort values error') }
  it { expect{ subject.update_value(:sort, {test: :one}) }.to raise_error(ArgumentError, 'sort values error') }
  it { expect{ subject.update_value(:sort, []) }.to raise_error(ArgumentError, 'sort values error') }
  it { expect{ subject.update_value(:sort, 'string') }.to raise_error(ArgumentError, 'sort values error') }
end
