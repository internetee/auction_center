class ResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def show
    @result = Result.where(user_id: current_user.id)
                    .accessible_by(current_ability)
                    .find(params[:id])
  end

  private

  def authorize_user
    authorize! :read, Result
  end
end
