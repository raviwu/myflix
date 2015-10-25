class AdminsController < AuthenticatedController
  before_action :require_admin

  def require_admin
    unless current_user.admin?
      access_deny
      flash[:danger] = "You are not authenticated to access that area."
      redirect_to root_path
    end
  end
end
