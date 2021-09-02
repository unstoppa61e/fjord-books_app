# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
