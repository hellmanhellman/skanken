class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_cooperative
    @cooperative = current_user.cooperative
  end

  def ensure_cooperative_admin
    return true unless !current_user.is?(:cooperative_admin)
    render nothing: true, status: 401
  end

  def user_start_page
    return true unless user_signed_in?
    redirect_to table_table_path
  end

  private
  def date_today
    time = Time.new
    unformatTime = Time.local(time.year, time.month, time.day).to_s
    formattedTime = unformatTime.gsub(/\s+/m, ' ').strip.split(" ")[0]
    return formattedTime
  end
end
