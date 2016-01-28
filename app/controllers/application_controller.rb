class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_filter :_reload_libs, :if => :_reload_libs?

  # def _reload_libs
  #   RELOAD_LIBS.each do |lib|
  #     require_dependency lib
  #   end
  # end

  # def _reload_libs?
  #   defined? RELOAD_LIBS
  # end
end
