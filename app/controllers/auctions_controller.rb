class AuctionsController < ApplicationController
  before_action :authorize_user
  before_action :enqueue_create_results_jobs, only: :index

  def index
    @auctions = Auction.active.accessible_by(current_ability)
  end

  def show
    @auction = Auction.accessible_by(current_ability).find(params[:id])
  end

  def authorize_user
    authorize! :read, Auction
  end

  def enqueue_create_results_jobs
    ResultCreationJob.perform_later if Auction.without_result.any?
    InvoiceCreationJob.perform_later if Result.pending_invoice.any?
  end
end
