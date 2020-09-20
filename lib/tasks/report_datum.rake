namespace :report_datum do
  desc "rake tsk for beggin update datume"

  task update: :environment do
    unless Date.today.saturday? || Date.today.sunday?
      CreateReportDatumJob.perform_now
    end
  end
end
