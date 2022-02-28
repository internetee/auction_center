module Admin
  class BansController < BaseController
    include OrderableHelper

    before_action :authorize_user
    before_action :set_ban, only: %i[show destroy]

    def search
      search_string = search_params[:search_string]
      @origin = search_string || search_params.dig(:order, :origin)
      @users = User.where('given_names ILIKE ? OR surname ILIKE ? OR email ILIKE ?',
                          "%#{@origin}%", "%#{@origin}%", "%#{@origin}%").all
      @billing_profile = BillingProfile.where('name ILIKE ?', "%#{@origin}%").all
      user_ids = (@users.ids + [@billing_profile.select(:user_id)]).uniq

      @bans = Ban.where(user_id: user_ids).order(orderable_array(default_order_params)).page(1)
    end

    # POST /admin/bans
    def create
      @ban = Ban.new(create_params)

      respond_to do |format|
        if @ban.save
          format.html { redirect_to admin_bans_path, notice: t(:created) }
          format.json { render :show, status: :created, location: @ban }
        else
          format.html { redirect_to admin_user_path(@ban.user), notice: t(:something_went_wrong) }
          format.json { render json: @ban.errors, status: :unprocessable_entity }
        end
      end
    end

    # GET /admin/bans
    def index
      @bans = Ban.includes(:user).order(orderable_array(default_order_params))
                 .page(params[:page])
    end

    # DELETE /admin/bans/1
    def destroy
      @ban.destroy
      respond_to do |format|
        format.html { redirect_to admin_bans_path, notice: t(:deleted) }
        format.json { head :no_content }
      end
    end

    private

    def search_params
      search_params_copy = params.dup
      search_params_copy.permit(:search_string, order: :origin)
    end

    def set_ban
      @ban = Ban.find(params[:id])
    end

    def create_params
      params.require(:ban).permit(:user_id, :valid_until)
    end

    def authorize_user
      authorize! :manage, Ban
    end

    def default_order_params
      { 'bans.valid_from' => 'desc' }
    end
  end
end
