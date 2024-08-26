class UsersController < ApplicationController
  before_action :require_user, only: %i[show destroy]
  before_action :require_group, only: %i[list]

  def create
    return render json: { message: 'Missing user parameters' }, status: :bad_request if user_params.empty?

    user = User.create(user_params.reject { |key| key == 'group_id' })
    unless user.errors.empty?
      return render json: { message: user.errors.full_messages }, status: :bad_request
    end

    begin
      user.groups << Group.find(user_params[:group_id])
    rescue ActiveRecord::RecordNotFound => e
      logger.warn("UsersController#create #{e.full_message}")
    end

    render json: user, status: :created
  end

  def show
    render json: @user
  end

  def list
    render json: { users: User.joins(:groups).where('groups.id' => @group.id) }
  end

  def destroy
    @user.destroy!

    render json: { message: 'User deleted' }, status: :ok

  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  private
  def user_params
    params[:user].permit(:first_name, :last_name, :email, :group_id)
  end
end
