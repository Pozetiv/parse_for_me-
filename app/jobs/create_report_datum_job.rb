class CreateReportDatumJob < ApplicationJob
  queue_as :default

  def perform
    Bank.all.each { |bank| UpdateBankDatumJob.perform_now(bank) }
  end
end
