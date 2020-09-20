class CreateReportData < ActiveRecord::Migration[6.0]
  def change
    create_table :report_data do |t|
      t.json :usd
      t.json :eur
      t.json :gold
      t.references :bank

      t.timestamps
    end
  end
end
