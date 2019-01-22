class ApplicationReport
  def initialize(options)
    @options = options
    @basename = @options[:basename] || 'Utan titel'

    create_workbook
    include_helpers
  end

  def generate!
    @action_view.render template: "reports/#{view_name}.xlsx.axlsx"
    @axlsx.serialize File.join(Rails.root, 'reports', "#{@basename}.xlsx")
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
    first_sheetname = @options[:first_sheetname] || @basename

    @axlsx = Axlsx::Package.new
    @workbook = @axlsx.workbook

    locals = { workbook: @workbook, first_sheetname: first_sheetname }
    locals.merge!(@options[:locals]) unless @options[:locals].empty?

    @action_view = ActionView::Base.new(ActionController::Base.view_paths, locals)
  end

  def require_helper(helper_class)
    filename = File.join(Rails.root, 'app', 'helpers', helper_class.to_s.underscore)
    return false unless File.exist? "#{filename}.rb"

    require filename
    true
  end

  def view_name
    self.class.name.underscore.sub(/_report/, '')
  end
end
