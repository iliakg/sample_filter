context 'check field hidden in form' do
  let(:options) do
    {
      title: {type: :string, hidden_input: false},
      amount: {type: :number},
      sort: {
        type: :sorting,
        values: [:id, :title, :amount],
        default_value: 'id_desc',
        hidden_input: true
      }
    }
  end

  subject { SampleFilter::ParamsSet.new(options) }

  it { expect(subject.hidden_input?(:title)).to eq(false) }
  it { expect(subject.hidden_input?(:amount)).to eq(false) }
  it { expect(subject.hidden_input?('sort')).to eq(true) }
end
