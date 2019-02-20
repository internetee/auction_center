module Admin
  class BansController < BaseController
    def create
      pp create_params
    end

    private

    def create_params
      params.require(:ban).permit(:user_id, :valid_until)
    end
  end
end
