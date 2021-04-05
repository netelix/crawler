module ApplicationHelper
  def bootstrap_form_with_mutation(mutation, url, modal = true, &block)
    bootstrap_form_with(mutation.form_params(url, modal: modal), &block)
  end
end
