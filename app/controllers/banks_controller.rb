class BanksController < ApplicationController
  def index
    @banks = Bank.all.includes(:report_datum)
  end

  def show
    @bank = Bank.find(params[:id])
    @pagy, @report_datums = pagy(@bank.report_datum)
  end
end
