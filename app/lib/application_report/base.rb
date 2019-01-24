# reload!; RefugeesReport.new(filename: 'refugees.xlsx', registered_from: "2019-01-01", registered_to: "2019-01-22", born_after: "2001-01-22", born_before: "2019-01-22").generate!
# reload!; EconomyReport.new(filename: 'economy.xlsx', from: "2018-10-01", to: "2018-12-31").generate!
# reload!; EconomyUppbokningReport.new(filename: 'economy_uppbokning.xlsx', from: "2018-10-01", to: "2018-12-31").generate!
# reload!; PlacementsReport.new(filename: 'placements.xlsx', from: "2018-10-01", to: "2018-12-31").generate!
# columns.map.each_with_index { |r, i| next i  if r[:type] == :date }.compact
# columns.map.each_with_index { |r, i| next [i, r[:tooltip]] if r[:tooltip] }.compact
# columns.map.each_with_index { |r, i| next [i, r[:style]] if r[:style] }.compact

module ApplicationReport
  class Base
    DEFAULT_INTERVAL = { from: Date.new(0), to: Date.today }.freeze

    def initialize(options)
      @options = options

      @filename   = options[:filename] || 'Utan titel.xlsx'
      @from       = options[:from]     || DEFAULT_INTERVAL[:from]
      @to         = options[:to]       || DEFAULT_INTERVAL[:to]
      @interval   = { from: @from, to: @to }
      @sheet_name = options[:sheet_name] ||= format_sheet_name

      create_workbook
      include_helpers
    end

    def generate!
      @action_view.render template: "reports/workbooks/#{view_name}.xlsx.axlsx"
      @axlsx.serialize File.join(Rails.root, 'reports', "#{@filename}")
    end

    protected

    def include_helpers
      require_helper(ReportHelper)
      helpers = [ReportHelper]

      class_name = self.class.name
      helper_class = "#{class_name}Helper"
      helpers << Object.const_get(helper_class) if require_helper(helper_class)

      @action_view.class_eval do
        helpers.each do |helper|
          include helper
        end
      end
    end

    private

    def create_workbook
      @axlsx = Axlsx::Package.new
      @workbook = @axlsx.workbook
      @style = ApplicationReport::Style.new(@axlsx)

      locals = {
        workbook: @workbook,
        style: @style,
        first_sheetname: @sheet_name,
        interval: @interval
      }
      locals.merge!(@options[:locals]) unless @options[:locals].empty?

      @action_view = ActionView::Base.new(ActionController::Base.view_paths, locals)
    end

    def require_helper(helper_class)
      filename = File.join(Rails.root, 'app', 'helpers', helper_class.to_s.underscore)
      return false unless File.exist? "#{filename}.rb"

      require filename
      true
    end

    def format_sheet_name
      @from && @to ? "#{@from.to_date}–#{@to.to_date}" : 'Inget intervall'
    end

    def view_name
      self.class.name.underscore.sub(/_report/, '')
    end

    def earliest_date(*dates)
      dates.flatten.compact.map(&:to_date).min
    end

    def latest_date(*dates)
      dates.flatten.compact.map(&:to_date).max
    end
  end
end
