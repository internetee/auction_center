module Admin
  class BansController < BaseController
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
      @bans = Ban.all.order(valid_until: :desc).page(params[:page])
    end

    # GET /admin/bans/1
    def show; end

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
  end
end
