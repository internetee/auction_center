class AuctionsController < ApplicationController
  before_action :authorize_user
  before_action :enqueue_create_results_jobs, only: :index

  # GET /
  def index
    @auctions = Auction.active.accessible_by(current_ability)
  end

  # GET /auctions/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    @auction = Auction.accessible_by(current_ability).find_by!(uuid: params[:uuid])
  end

  def authorize_user
    authorize! :read, Auction
  end

  def enqueue_create_results_jobs
    ResultCreationJob.perform_later if ResultCreationJob.needs_to_run?
    InvoiceCreationJob.perform_later if InvoiceCreationJob.needs_to_run?
  end
end
