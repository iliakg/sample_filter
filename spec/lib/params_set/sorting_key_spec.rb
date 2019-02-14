context 'get sorting key' do
  subject { SampleFilter::ParamsSet.new(options) }

  context 'when options has one sorting field' do
    let(:options) do
      {
        title: {type: :string},
        amount: {type: :number},
        "sort" => {
          type: :sorting,
          values: [:id, :title, :amount],
          default_value: :id_desc
        }
      }
    end

    it { expect(subject.sorting_key).to eq(:sort) }
  end

  context 'when options has two sorting field' do
    let(:options) do
      {
        title: {type: :string},
        amount: {type: :number},
        sort: {
          type: :sorting,
          values: [:id, :title, :amount],
          default_value: 'id_desc'
        },
        another_sort: {
          type: :sorting,
          values: [:field, :one_field],
          default_value: 'field_desc'
        }
      }
    end

    it { expect(subject.sorting_key).to eq(:sort) }
  end

  context 'when options does not have sorting field' do
    let(:options) { {title: {type: :string}, amount: {type: :number}} }

    it { expect(subject.sorting_key).to be_nil }
  end
end
