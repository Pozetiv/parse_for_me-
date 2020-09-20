class ReportDatum < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :bank
end
