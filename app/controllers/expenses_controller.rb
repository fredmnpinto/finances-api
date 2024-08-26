class ExpensesController < ApplicationController
  before_action :require_expense, only: %i[show destroy]
  before_action :require_group, only: %i[index create]

  def create
    return render json: { message: 'Missing expense parameters' }, status: :bad_request if expense_params.empty?

    expense = Expense.create(expense_params.merge(group: @group))
    unless expense.errors.empty?
      return render json: { message: expense.errors.full_messages }, status: :bad_request
    end

    expense.save

    render json: expense, status: :created
  end

  def show
    render json: @expense
  end

  def index
    render json: { groups: Expense.joins(:group).where('groups.id' => @group.id) }
  end

  def destroy
    @expense.destroy!

    render json: { message: 'Expense deleted' }, status: :ok

  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  private
  def expense_params
    params[:expense].permit(%i[title description amount currency])
  end
end
