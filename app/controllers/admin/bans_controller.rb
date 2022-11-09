module Admin
  class BansController < BaseController
    include OrderableHelper

    before_action :authorize_user
    before_action :set_ban, only: %i[show destroy]

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
      sort_column = params[:sort].presence_in(%w{ users.surname valid_from valid_until domain_name invoice_id }) || "users.surname"
      sort_direction = params[:direction].presence_in(%w{ asc desc }) || "desc"

      bans = Ban.includes(:user).search(params).order("#{sort_column} #{sort_direction}")
      @pagy, @bans = pagy(bans, items: params[:per_page] ||= 20)
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

    def set_ban
      @ban = Ban.find(params[:id])
    end

    def create_params
      params.require(:ban).permit(:user_id, :valid_until)
    end

    def authorize_user
      authorize! :manage, Ban
    end
  end
end
