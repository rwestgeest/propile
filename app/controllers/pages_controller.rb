class PagesController < ApplicationController
  def show
    page = params[:id] || 'index'
    render :action => page
  end
end
