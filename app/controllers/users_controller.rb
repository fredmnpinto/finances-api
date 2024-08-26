class UsersController < ApplicationController
  before_action :require_user, only: %i[show destroy update]
  before_action :require_group, only: %i[list create]
  before_action :require_user_params, only: %i[create update]

  def create
    user = User.create(user_params.merge(groups: [@group]))
    unless user.errors.empty?
      return render json: { message: user.errors.full_messages }, status: :bad_request
    end

    render json: user, status: :created
  end

  def show
    render json: @user
  end

  def list
    render json: { users: User.joins(:groups).where('groups.id' => @group.id) }
  end

  def update
    @user.update(user_params)

    render json: @user, status: :ok
  end

  def destroy
    @user.destroy!

    render json: { message: 'User deleted' }, status: :ok

  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  private
  def user_params
    params[:user]&.permit(:first_name, :last_name, :email)
  end

  def require_user_params
    render json: { message: 'Missing user parameters' }, status: :bad_request if user_params.nil?
  end
end
