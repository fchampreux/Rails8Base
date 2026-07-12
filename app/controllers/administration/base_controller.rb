class Administration::BaseController < ApplicationController
  include Pagy::Backend

  layout "administration"

  before_action :require_admin!

  private

  def require_admin!
    redirect_to root_path, alert: "Accès réservé aux administrateurs." unless current_user.is_admin?
  end
end
