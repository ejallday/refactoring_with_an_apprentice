module Features
  module FormHelpers
    def within_form(prefix, &block)
      completion_helper = FormCompletionHelper.new(form_prefix, self)
      yield completion_helper
    end
  end
end
