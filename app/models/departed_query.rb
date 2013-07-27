class DepartedQuery
  def initialize(scope)
    @scope = scope
  end

  def find
    scope.joins(:assignment).where{assignment.application_type=='Departure'}
  end

  private

  def scope
    @scope
  end
end
