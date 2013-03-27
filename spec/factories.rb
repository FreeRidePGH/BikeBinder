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

  sequence(:bike_brand_name){|n|"test brand #{n}"}
  factory :bike_brand do
    name {generate :bike_brand_name}
  end

  sequence(:bike_model_name){|n|"test model series #{n}"}
  factory :bike_model do
    name {generate :bike_model_name}
  end
  
  factory :bike_model_with_brand, :class => :bike_model do
    name {generate :bike_model_name}
    association :brand, :factory => :bike_brand
  end

  factory :assignment do
    bike
    association :application, :factory => :program
  end

  factory :assignment_departed_prog, :class => :assignment do
    bike
    association :application, :factory => :departure_with_prog
  end

  factory :assignment_departed_dest, :class => :assignment do
    bike
    association :application, :factory => :departure_with_dest
  end

  factory :departure_with_prog, :class => :departure do
    value 0
    association :application, :factory => :program    
  end

  factory :departure_with_dest, :class=> :departure do
    value 0
    association :application, :factory => :destination
  end

  sequence(:bike_number, 1000){|n| BikeNumber.format_number(n)}
  factory :bike do

    number {generate :bike_number}

    val = 100
    n_bike_info = 1
    
    color 'FFFFFF'
    seat_tube_height Unit.new("540 #{Settings::LinearUnit.persistance.units}")
    top_tube_length  Unit.new("560 #{Settings::LinearUnit.persistance.units}")
    
    factory :bike_with_model do
      association :model, :factory => :bike_model_with_brand
      number {generate :bike_number}      
      color '00FF00'
    end
  end

  sequence(:hook_number){|n| "#{(n%90+10)}H"}
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
