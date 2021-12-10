class UnsubscribeController < ApplicationController
  def unsubscribe
    user = Rails.application.message_verifier(:unsubscribe).verify(params[:id])
    @user = User.find(user)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'Subscription Cancelled'
      redirect_to root_url
    else
      flash[:alert] = 'Something wrong'
      render :unsubscribe
    end
  end

  private

  def user_params
    params.require(:user).permit(:daily_summary)
  end
end
