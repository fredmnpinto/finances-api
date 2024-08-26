class ApplicationController < ActionController::API
  protected
  def require_user
    return render json: { message: 'Missing user parameters' }, status: :bad_request unless params.keys.any? { |param_key| %w[user_id user_email].include?(param_key) }

    @user = User.find(params[:user_id]) if params[:user_id]
    @user = User.find_by_email(params[:user_email]) if params[:user_email]

    render json: { message: 'User not found' }, status: :not_found if @user.nil?
  end

  def require_group
    return render json: { message: 'Missing group parameters' }, status: :bad_request unless params.keys.any? { |param_key| %w[group_id].include?(param_key) }

    @group = Group.find(params[:group_id]) if params[:group_id]

    render json: { message: 'Group not found' }, status: :not_found if @group.nil?
  end
end
