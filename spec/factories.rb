FactoryGirl.define do
  
  factory :hook do
    sequence(:number){|n| (100+n).to_s}
  end

  factory :user do
    email "test@freeridepgh.org"
    password "testtest"
    password_confirmation "testtest"
  end


  factory :bike_brand do
    name 'test brand'
  end

  factory :bike_model do
    sequence(:name){|n| "test model series #{n}"}
    bike_brand_id 1
  end

  factory :bike do

    sequence(:number){|n| Bike.format_number(10000+n)}

    val = 100

    n_bike_info = 1
    
    color 'FFFFFF'
    seat_tube_height 21
    top_tube_length  19
    
    bike_model_id 1

  end

  factory :project_category do
    sequence(:name){|n| "Category#{n}"}
    project_type "Project::Eab"
    max_programs 3
  end

  factory :program, :aliases => [:prog] do
    sequence(:title){|n| "TestProgram#{n}"}
    project_category
  end

  factory :youth_detail, :class => "Project::YouthDetail" do
    association :proj, :factory => :youth_project
  end

  factory :youth_project, :class => "Project::Youth" do
    prog
    bike
    project_category
    #factory :youth_project_with_detail do
    #  after(:build) do |proj_instance|
    #    detail FactoryGirl.build(:youth_detail)
    #  end
    #end
    #association :detail, :factory => :youth_detail
  end

  factory :eab_project, :class => "Project::Eab" do
    prog
    bike
    project_category
  end

  factory :eab_detail, :class => "Project::EabDetail" do
    association :proj, :factory => :eab_project
  end

end
