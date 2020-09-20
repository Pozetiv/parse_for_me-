class UpdateBankDatumJob < ApplicationJob
  queue_as :default

  def perform(bank)
    UpdateDataForBanks.new.send("update_for_#{bank.name}")
  end
end