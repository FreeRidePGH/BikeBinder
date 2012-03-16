class Project::Spec::Youth < ActiveRecord::Base
  belongs_to :specable, :polymorphic => :true
end
