require 'report'

class GenerateReportJob < ApplicationJob
  queue_as :default

  def perform(params, file_id)
  end
end
