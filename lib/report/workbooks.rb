require 'report/workbooks/homes'
require 'report/workbooks/placements'
require 'report/workbooks/refugees'
require 'report/workbooks/economy'

class Report
  class Workbooks
    def self.spreadsheet_formula(costs_and_days)
      formulas = costs_and_days.map do |cd|
        "(#{cd[:days]}*#{cd[:cost]})"
      end
      "=#{formulas.join('+')}"
    end
  end
end
