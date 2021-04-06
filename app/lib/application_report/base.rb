# This is an abstract class used for subclassing Excel report generation classes.
# See app/reports for implementation examples
module ApplicationReport
  class Base
    def initialize(options)
      @options = options

      @filename   = options[:filename] || 'Utan titel.xlsx'
      @from       = options[:from]
      @to         = options[:to]
      @interval   = { from: @from, to: @to }
      @sheet_name = options[:sheet_name] ||= format_sheet_name

      create_workbook
    end

    def generate!
      ApplicationController.new.render_to_string template: "report_workbooks/#{view_name}", layout: false, assigns: @locals
      @axlsx.serialize File.join(Rails.root, 'reports', @filename)
    end

    private

    def create_workbook
      @axlsx = Axlsx::Package.new
      @workbook = @axlsx.workbook
      @style = ApplicationReport::Style.new(@axlsx)

      @locals = {
        workbook: @workbook,
        style: @style,
        first_sheetname: @sheet_name,
        interval: @interval
      }

      @locals.merge!(@options[:locals]) unless @options[:locals].nil?
    end

    def require_helper(helper_class)
      filename = File.join(HELPERS_PATH, helper_class.to_s.underscore)
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
