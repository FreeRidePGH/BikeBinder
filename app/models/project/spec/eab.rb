class Project::Spec::Eab < ActiveRecord::Base
  belongs_to :specable, :polymorphic => :true
end
