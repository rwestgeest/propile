module ApplicationHelper
  def errors_for record
    render :partial => 'shared/form_errors', locals: { record: record }
  end
end
