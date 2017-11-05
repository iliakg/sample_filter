require 'ar_helper'

context 'create new entity with config' do
  before do
    class Entity < ActiveRecord::Base
      sample_filter title: {type: :string}
    end

    Entity.create(title: 'text')
  end

  it 'shoud create user and define params set' do
    expect(Entity.count).to eq(1)
    expect(Entity.filter_params_set).to be_a(SampleFilter::ParamsSet)
  end
end
