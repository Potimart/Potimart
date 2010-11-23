#
# Include this in your spec/spec_helper.rb
#
class ActiveForm::Base
  # As added on ActiveRecord::Base by 
  # spec/rails/extensions/active_record/base.rb:
  def errors_on(attribute)
    self.valid?
    [self.errors.on(attribute)].flatten.compact
  end
  alias :error_on :errors_on
  
end
