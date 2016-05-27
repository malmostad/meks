class ErrorsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  skip_before_action :authenticate

  def not_found
    logger.warn "Not found: #{request.fullpath}"
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end
end
