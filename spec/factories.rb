FactoryGirl.define do

  factory :user do
    email "test@freeridepgh.org"
    password "testtest"
    password_confirmation "testtest"
  end

  sequence(:program_name){|n| "TestProgram#{n}"}
  sequence(:program_label){|n| "TProg#{n}"}
  factory :program, :aliases => [:prog] do
    name {generate :program_name}
    label{generate :program_label}
  end
  factory :associated_program, :class => :program do
    name {generate :program_name}
    label{generate :program_label}
  end

  sequence(:dest_name){|n| "TestProgram#{n}"}
  sequence(:dest_label){|n| "TProg#{n}"}
  factory :destination, :aliases => [:dest] do
    name {generate :dest_name}
    label {generate :dest_label}
  end

  sequence :bike_brand_name do |n|
    "test brand #{n}"
  end
  factory :bike_brand do
    name {generate :bike_brand_name}
  end

  sequence :bike_model_name do |n|
    "test model series #{n}"
  end
  factory :bike_model do
    name {generate :bike_model_name}
    bike_brand_id 1
  end

  factory :assignment do
    bike
    association :application, :factory => :program
  end

  sequence :bike_number, 1000 do |n|
    BikeNumber.format_number(n)
  end
  factory :bike do

    number {generate :bike_number}

    val = 100
    n_bike_info = 1
    
    color 'FFFFFF'
    seat_tube_height Unit.new('21')*Settings::LinearUnit.persistance.units
    top_tube_length  Unit.new('19')*Settings::LinearUnit.persistance.units
    
    bike_model_id 1
  end
  sequence :hook_number do |n|
    "#{n+10}H"
  end
  factory :hook do
    number {generate :hook_number}
  end

  factory :associated_hook, :class => :hook do
    number {generate :hook_number}
  end
  factory :associated_bike, :class => :bike do
    number {generate :bike_number}
    color 'FFFFFF'
  end

  factory :hook_reservation do
    association :hook, :factory => :associated_hook
    association :bike, :factory => :associated_bike
  end

end
