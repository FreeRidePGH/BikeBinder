class Project::Spec::Eab < ActiveRecord::Base
  belongs_to :specable, :polymorphic => :true

  attr_accessible nil
end