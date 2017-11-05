context 'update attributes for params set' do
  let(:options) do
    {
      title: {type: :string},
      amount: {type: :number},
      'created_at' => {'type' => 'date', default_value: {from: '09.11.2016', to: '17.11.2017'}},
      kind: {
        type: 'list',
        values: {red: 1, 'green' => '2'},
        default_value: 2
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

  let(:updated_options) do
    {
      title: '',
      amount: '123',
      created_at: {from: '01.01.2016', to: '23.11.2017'},
      status: 'confirm',
      confirmed: 't',
      invalid_field: 123,
      sort: 'title_desc'
    }
  end

  subject { SampleFilter::ParamsSet.new(options) }

  it 'update valid attributes' do
    subject.update_attributes(ActionController::Parameters.new(updated_options))
    expect(subject.title).to eq('')
    expect(subject.amount).to eq('123')
    expect(subject.created_at).to eq({from: '01.01.2016', to: '23.11.2017'})
    expect(subject.kind).to eq('2')
    expect(subject.status).to eq('confirm')
    expect(subject.confirmed).to eq('t')
    expect(subject.sort).to eq('title_desc')
    subject.update_attributes(ActionController::Parameters.new({}))
    expect(subject.created_at).to eq({from: '09.11.2016', to: '17.11.2017'})
    expect(subject.sort).to eq('id_desc')
  end
end
