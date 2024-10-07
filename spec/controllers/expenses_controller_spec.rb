# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesController do
  before :each do
    @group = FactoryBot.create(:group)
    @expenses = FactoryBot.create_list(:expense, 10, group: @group)
    @expense = @expenses.first
  end

  describe '#index' do
    context 'when a group is supplied' do
      before :each do
        get :index, params: { group_id: @group.id }
      end

      it { should respond_with :success }

      it 'should return all users from the group' do
        expect(response.body).to include(@expenses.to_json)
      end
    end

    context 'when a group is not supplied' do
      before :each do
        get :index, params: { group_id: nil }
      end

      it { should respond_with :not_found }

      it 'should render group missing error' do
        expect(JSON.parse(response.body)['message']).to eq('Group not found')
      end
    end
  end

  describe '#show' do
    context 'when an expense is supplied' do
      before :each do
        @expense = FactoryBot.create(:expense)

        get :show, params: { expense_id: @expense.id }
      end

      it { should respond_with :success }

      it 'should have all info on the expense' do
        expect(response.body).to include(@expense.to_json)
      end
    end
  end

  describe '#update' do
    context 'when an expense is supplied' do
      before :each do
        patch :update, params: { expense_id: @expense.id, expense: { title: 'UPDATED!' } }
      end

      it { should respond_with :success }

      it 'should have all updated info on the expense' do
        expect(JSON.parse(response.body)).to include(JSON.parse(@expense.reload.to_json))
      end

      it 'should update the expense' do
        expect(@expense.reload.title).to eq('UPDATED!')
      end
    end

    context 'when user parameters are not supplied' do
      before :each do
        patch :update, params: { expense_id: @expense.id }
      end

      it { should respond_with :bad_request }
    end
  end

  describe '#create' do
    context 'when valid parameters are supplied' do
      before :each do
        @expense = FactoryBot.build(:expense, group: @group)
      end

      context 'when a group is supplied' do
        before :each do
          post :create, params: { group_id: @group.id, expense: expense_parameters(@expense) }
        end

        it { is_expected.to respond_with :created }
      end
    end

    context 'when invalid parameters are supplied' do
      before :each do
        @expense = FactoryBot.build(:expense, group: @group, amount: nil)
        post :create, params: { group_id: @group.id, expense: expense_parameters(@expense) }
      end

      it { is_expected.to respond_with :bad_request }

      it 'should render the reasons it\'s invalid' do
        expect(JSON.parse(response.body)['message']).to include('Amount can\'t be blank')
      end
    end
  end

  describe '#destroy' do
    context 'when a expense is supplied' do
      before :each do
        delete :destroy, params: { expense_id: @expense.id }
      end

      it { should respond_with :success }

      it 'should destroy the expense' do
        expect(User.exists?(id: @expense.id)).to be_falsey
      end
    end

    context 'when a non-existing expense is supplied' do
      before :each do
        delete :destroy, params: { expense_id: '99' }
      end

      it { is_expected.to respond_with :not_found }

      it 'should render the error' do
        expect(JSON.parse(response.body)['message']).to include("Expense not found")
      end
    end

    context 'when destroy fails' do
      before :each do
        @error_message = "Sample message"
        Expense.any_instance.stubs(:destroy!).raises StandardError, @error_message

        delete :destroy, params: { expense_id: @expense.id }
      end

      it { is_expected.to respond_with :internal_server_error }

      it 'should render the error' do
        expect(JSON.parse(response.body)['message']).to include(@error_message)
      end
    end

  end

  def expense_parameters(expense)
    expense.serializable_hash.except('id', 'created_at', 'updated_at')
  end
end
