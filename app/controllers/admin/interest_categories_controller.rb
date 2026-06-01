module Admin
  class InterestCategoriesController < BaseController
    before_action :authorize_user
    before_action :set_interest_category, only: %i[edit update destroy]

    # GET /admin/interest_categories
    def index
      @interest_categories = InterestCategory.ordered
    end

    # GET /admin/interest_categories/new
    def new
      @interest_category = InterestCategory.new(active: true, position: next_position)
    end

    # POST /admin/interest_categories
    def create
      @interest_category = InterestCategory.new(interest_category_params)

      if @interest_category.save
        redirect_to admin_interest_categories_path, notice: t(:created)
      else
        render :new, status: :unprocessable_entity
      end
    end

    # GET /admin/interest_categories/1/edit
    def edit; end

    # PUT /admin/interest_categories/1
    def update
      if @interest_category.update(interest_category_params)
        redirect_to admin_interest_categories_path, notice: t(:updated)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/interest_categories/1
    def destroy
      @interest_category.destroy
      redirect_to admin_interest_categories_path, notice: t(:deleted)
    end

    private

    def set_interest_category
      @interest_category = InterestCategory.find(params[:id])
    end

    def interest_category_params
      params.require(:interest_category)
            .permit(:code, :name_en, :name_et, :position, :active)
    end

    def next_position
      (InterestCategory.maximum(:position) || 0) + 1
    end

    def authorize_user
      authorize! :manage, InterestCategory
    end
  end
end
