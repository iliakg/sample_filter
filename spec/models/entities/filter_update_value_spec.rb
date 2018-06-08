require 'ar_helper'

context 'update entity field value' do
  before do
    class Entity < ActiveRecord::Base
      sample_filter kind: {type: :list,values: [:confirm, 'unconfirm']}
    end

    Entity.create(title: 'text')
  end

  it 'shoud create user and define params set' do
    expect(Entity.filter_params_set.values_for(:kind)).to eq(['confirm', 'unconfirm'])
    Entity.filter_update_value('kind', [:black, :white])
    expect(Entity.filter_params_set.values_for(:kind)).to eq(['black', 'white'])
  end
end
