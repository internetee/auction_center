module Admin
  class BansController < BaseController
    include OrderableHelper
    include PagyHelper
    include Pagy::Backend


    before_action :authorize_user
    before_action :set_ban, only: %i[show destroy]

    # def search
    #   search_string = search_params[:search_string]
    #   @users = User.where('given_names ILIKE ? OR surname ILIKE ? OR email ILIKE ?',
    #                       "%#{search_string}%", "%#{search_string}%", "%#{search_string}%").all
    #   @billing_profile = BillingProfile.where('name ILIKE ?', "%#{search_string}%").all
    #   user_ids = (@users.ids + [@billing_profile.select(:user_id)]).uniq

    #   bans = Ban.where(user_id: user_ids).uniq
    #   @pagy, @bans = pagy(bans, items: params[:per_page] ||= 20)
    # end

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
      sort_column = params[:sort].presence_in(%w{ users.surname valid_from valid_until domain_name invoice_id }) || "id"
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
