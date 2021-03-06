class BikeReport

  include Datagrid

  def self.assigned_query(scope=Bike)
    scope.joins(:assignment)
  end

  def self.unassigned_query(scope=Bike)
    scope.includes(:assignment).where{id.not_in my{assigned_query(scope)}.select{id}}
  end

  def self.departed_query(scope=Bike)
    DepartedQuery.new(scope).find
  end

  def self.present_query(scope=Bike)
    scope.where{id.not_in my{departed_query(scope)}.select{id}}
  end

  scope do
    Bike.includes(:bike_model, :bike_brand,:assignment, :hook).
      includes(:hook_reservation=>[:hook]).references('')
  end

  filter(:departed, :boolean) { |val, scope| BikeReport.departed_query(scope) }
  filter(:present, :boolean) { |val, scope| BikeReport.present_query(scope) }

  filter(:available, :boolean) { |b, scope| BikeReport.unassigned_query(scope)}
  filter(:assigned, :boolean) { |b, scope| BikeReport.assigned_query(scope)}

  filter(:program, :integer, :multiple => true) do |prog_id, scope|
    prog_ids = prog_id.map{|id| id.to_i}
    DepartedQuery.new(scope).find.includes(:assignment).where{
      (assignment.application_id.in my{prog_ids})
    }+
    scope.includes{:assignment}.where{
      assignment.application_id.in my{prog_ids}
    }
  end

  filter(:destination, :integer, :multiple => true) do |dest_id, scope|
    scope
  end

  filter(:number_record)
  filter(:wheel_size)

  column(:number)
  column(:color)
  column(:color_name) do
    color.name
  end
  column(:wheel_size)
  column(:brand_name, :order =>"bike_brand.name") do 
    brand.name if brand
  end
  column(:model_name, :order => "bike_model.name") do
    model.name if model
  end
  
  column(:seat_tube_height)
  column(:top_tube_length)
  column(:quality)
  column(:condition)
  column(:value)

  column(:hook_number) do
    (hook) ? hook.number : 'n/a'
  end
  
  column(:status, :order => "assignment.application.name") do 
    application.name if application
  end

  column(:arrival_date) do
    Settings::Date.new(created_at).long_s
  end

  column(:departure_date) do
    if application.respond_to?(:departed_at)
      Settings::Date.new(application.departed_at).long_s
    else
      ""
    end
  end
end
