module ReportGenerator
  extend ActiveSupport::Concern

  included do
    def generate_xlsx(template_name, records)
      @axlsx   = Axlsx::Package.new
      template = Template.new(@axlsx)

      template.send(template_name, records)
      @axlsx
    end

    def send_xlsx(xlsx, base_name)
      Rails.logger.debug xlsx
      send_data xlsx.to_stream.read, type: :xlsx, disposition: "attachment",
        filename: "#{base_name}_#{DateTime.now.strftime('%Y-%m-%d_%H%M%S')}.xlsx"
    end
  end
end
