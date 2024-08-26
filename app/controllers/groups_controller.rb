class GroupsController < ApplicationController
  before_action :require_group, only: %i[show destroy]
  before_action :require_user, only: %i[index]

  def create
    return render json: { message: 'Missing group parameters' }, status: :bad_request if group_params.empty?

    group = Group.create(group_params)
    unless group.errors.empty?
      return render json: { message: group.errors.full_messages }, status: :bad_request
    end

    render json: group, status: :created
  end

  def show
    render json: @group
  end

  def index
    render json: { groups: Group.joins(:users).where('users.id' => @user.id) }
  end

  def destroy
    @group.destroy!

    render json: { message: 'Group deleted' }, status: :ok

  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  private
  def group_params
    params[:group].permit(%i[name])
  end
end
