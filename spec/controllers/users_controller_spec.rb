# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  before :each do
    @user = FactoryBot.create(:user)
  end

  describe '#index' do
    context 'when a group is supplied' do
      before :each do
        @group = FactoryBot.create(:group)
        @users = FactoryBot.create_list(:user, 2, groups: [@group])
        get :index, params: { group_id: @group.id }
      end

      it { should respond_with :success }

      it 'should return all users from the group' do
        expect(response.body).to include(@users.to_json)
      end
    end

    context 'when a group is not supplied' do
      before :each do
        get :index
      end

      it { should respond_with :bad_request }
    end
  end

  describe '#show' do
    context 'when a user is supplied' do
      before :each do
        @user = FactoryBot.create(:user)

        get :show, params: { user_id: @user.id }
      end

      it { should respond_with :success }

      it 'should have all info on the user' do
        expect(response.body).to include(@user.to_json)
      end
    end
  end

  describe '#create' do
    context 'when a group is supplied' do
      before :each do
        @group = FactoryBot.create(:group)
        @request_user = FactoryBot.build(:user, groups: [@group])

        post :create, params: { user: { first_name: @request_user.first_name, last_name: @request_user.last_name, email: @request_user.email }, group_id: @group.id }
      end

      it { should respond_with :created }

      it 'should create the user' do
        expect(response.body).to include(User.find_by_first_name(@request_user.first_name).to_json)
      end
    end

    context 'when a group is not supplied' do
      before :each do
        @request_user = FactoryBot.build(:user)

        post :create, params: { user: { first_name: @request_user.first_name, last_name: @request_user.last_name, email: @request_user.email } }
      end

      it { should respond_with :bad_request }

      it 'should not create the user' do
        expect(User.find_by_first_name(@request_user.first_name)).to be_nil
      end
    end

    context 'when the user parameters are not valid' do
      before :each do
        @group = FactoryBot.create(:group)
        @request_user = FactoryBot.build(:user, email: nil)

        post :create, params: { user: { first_name: @request_user.first_name, last_name: @request_user.last_name, email: @request_user.email }, group_id: @group.id }
      end

      it { is_expected.to respond_with :bad_request }

      it 'should display the invalid attributes' do
        expect(JSON.parse(response.body)['message']).to include("Email can't be blank")
      end
    end
  end

  describe '#update' do
    context 'when a user is supplied' do
      before :each do
        patch :update, params: { user_id: @user.id, user: { first_name: 'UPDATED!' } }
      end

      it { should respond_with :success }

      it 'should have all updated info on the user' do
        expect(JSON.parse(response.body)).to include(JSON.parse(@user.reload.to_json))
      end

      it 'should update the user' do
        expect(@user.reload.first_name).to eq('UPDATED!')
      end
    end

    context 'when user parameters are not supplied' do
      before :each do
        patch :update, params: { user_id: @user.id }
      end

      it { should respond_with :bad_request }
    end
  end

  describe '#destroy' do
    context 'when a user is supplied' do
      before :each do
        delete :destroy, params: { user_id: @user.id }
      end

      it { should respond_with :success }

      it 'should destroy the user' do
        expect(User.exists?(id: @user.id)).to be_falsey
      end
    end

    context 'when a non-existing user is supplied' do
      before :each do
        delete :destroy, params: { user_id: '99' }
      end

      it { is_expected.to respond_with :not_found }

      it 'should render the error' do
        expect(JSON.parse(response.body)['message']).to include("User not found")
      end
    end

    context 'when destroy fails' do
      before :each do
        @error_message = "Sample message"
        User.any_instance.stubs(:destroy!).raises StandardError, @error_message

        delete :destroy, params: { user_id: @user.id }
      end

      it { is_expected.to respond_with :internal_server_error }

      it 'should render the error' do
        expect(JSON.parse(response.body)['message']).to include(@error_message)
      end
    end

  end
end
