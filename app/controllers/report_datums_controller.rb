class ReportDatumsController < ApplicationController

  def do_update
    UpdateBankDatumJob.perform_now(bank)
    respond_to :js
  end

  private

  def bank
    Bank.find(params[:bank_id])
  end
end
