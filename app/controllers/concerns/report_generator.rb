module ReportGenerator
  extend ActiveSupport::Concern

  included do
    def generate_xlsx(template_name, records)
      @axlsx   = Axlsx::Package.new
      template = Template.new(@axlsx)

      template.send(template_name, records)
    end

    def send_xlsx(stream, base_name)
      send_data @axlsx.to_stream.read, type: :xlsx, disposition: "attachment",
        filename: "#{base_name}_#{DateTime.now.strftime('%Y-%m-%d_%H%M%S')}.xlsx"
    end
  end

  module ClassMethods
  end
end
