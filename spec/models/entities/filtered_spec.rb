require 'ar_helper'

context 'filtered entities' do
  before do
    class Entity < ActiveRecord::Base
      sample_filter(
        {
          title: {type: :string, default_value: 'test_title'},
          amount: {type: :number},
          'created_at' => {'type' => 'date'},
          kind: {
            type: 'list',
            values: {red: 1, 'green' => '2'}
          },
          status: {
            type: :list,
            values: [:confirm, 'unconfirm']
          },
          confirmed: {type: :boolean, default_value: true},
          sort: {
            type: :sorting,
            values: [:id, 'created_at', :amount],
            default_value: 'amount_desc'
          }
        }
      )
    end
  end

  let!(:entity1) { Entity.create(title: 'test_title1', amount: 430, kind: 1, status: 'confirm', confirmed: true, created_at: Time.current - 1.minute) }
  let!(:entity2) { Entity.create(title: 'test_title2', amount: 123, kind: 2, status: 'confirm', confirmed: true, created_at: Time.current - 1.days) }
  let!(:entity3) { Entity.create(title: 'test_title3', amount: 20, kind: 4, status: 'unconfirm', confirmed: false, created_at: Time.current - 5.days) }
  let!(:entity4) { Entity.create(title: 'blablabla', amount: 100, kind: 1, status: 'confirm', confirmed: true, created_at: Time.current - 9.days) }
  let!(:entity5) { Entity.create(title: 'test_title5', amount: 20, kind: 1, status: 'confirm', confirmed: true, created_at: Time.current - 13.days) }

  let(:full_list) { [entity1.id, entity2.id, entity3.id, entity4.id, entity5.id] }

  it 'shoud return full list if params empty' do
    expect(Entity.filtered(nil).map(&:id)).to eq([entity1.id, entity2.id, entity5.id])
  end

  it 'shoud return entities list for combine two fields' do
    expect(Entity.filtered(ActionController::Parameters.new({title: 'itle3', amount: 20})).map(&:id)).to eq([entity3.id])
  end

  it 'shoud return entities list for number' do
    expect(Entity.filtered(ActionController::Parameters.new({amount: 20})).map(&:id)).to eq([entity3.id, entity5.id])
  end

  it 'shoud return entities list for boolean' do
    expect(Entity.filtered(ActionController::Parameters.new({title: 'est', confirmed: 'f'})).map(&:id)).to eq([entity3.id])
    expect(Entity.filtered(ActionController::Parameters.new({title: 'est', confirmed: 't'})).map(&:id)).to eq([entity1.id, entity2.id, entity5.id])
    expect(Entity.filtered(ActionController::Parameters.new({title: 'est', confirmed: ''})).map(&:id)).to eq([entity1.id, entity2.id, entity3.id, entity5.id])
  end

  it 'shoud return entities list for list type' do
    expect(Entity.filtered(ActionController::Parameters.new({kind: '1'})).map(&:id)).to eq([entity1.id, entity4.id, entity5.id])
    expect(Entity.filtered(ActionController::Parameters.new({kind: 2})).map(&:id)).to eq([entity2.id])
    expect(Entity.filtered(ActionController::Parameters.new({kind: 4})).map(&:id)).to eq([entity3.id])
    expect(Entity.filtered(ActionController::Parameters.new({kind: ''})).map(&:id)).to eq(full_list)

    expect(Entity.filtered(ActionController::Parameters.new({status: 'confirm'})).map(&:id)).to eq([entity1.id, entity2.id, entity4.id, entity5.id])
    expect(Entity.filtered(ActionController::Parameters.new({status: :unconfirm})).map(&:id)).to eq([entity3.id])
    expect(Entity.filtered(ActionController::Parameters.new({status: ''})).map(&:id)).to eq(full_list)
  end

  it 'shoud return entities list for date' do
    params1 = ActionController::Parameters.new(created_at: {from: (Time.current - 5.days).strftime('%d.%m.%Y'), to: (Time.current).strftime('%d.%m.%Y %H:%M')})
    params2 = ActionController::Parameters.new(created_at: {from: (Time.current - 9.days - 1.minute).strftime('%d.%m.%Y %H:%M')})
    params3 = ActionController::Parameters.new(created_at: {to: (Time.current - 5.days).strftime('%d.%m.%Y')})

    expect(Entity.filtered(params1).map(&:id)).to eq([entity1.id, entity2.id, entity3.id])
    expect(Entity.filtered(params2).map(&:id)).to eq([entity1.id, entity2.id, entity3.id, entity4.id])
    expect(Entity.filtered(params3).map(&:id)).to eq([entity4.id, entity5.id])
  end

  it 'shoud sort entities list' do
    expect(Entity.filtered(ActionController::Parameters.new({title: 'test_title', sort: "amount_asc"})).map(&:id)).to eq([entity3.id, entity5.id, entity2.id, entity1.id])
  end
end
