require './app/helpers/application_helper'

axlsx = Axlsx::Package.new
@workbook = axlsx.workbook

view_assigns = { workbook: @workbook, legal_codes: LegalCode.all }
action_view = ActionView::Base.new(ActionController::Base.view_paths, view_assigns)
action_view.class_eval do
  include ApplicationHelper
end

action_view.render template: 'reports/economy.xlsx.axlsx'
axlsx.serialize File.join(Rails.root, 'reports', 'axlsx.xlsx')
