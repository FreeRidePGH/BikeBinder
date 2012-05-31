class ProjectDetailVersion < Version
  self.table_name = :project_detail_versions
  
  attr_accessible :state

  # Get the state transition context for a given list of versions
  # from is the origin for this state
  # from could be first version for this state (maybe as an option)
  #
  # to is the state that the latest version transitioned to
  # 
  def self.transition_context(v)
    retval = {}     

    origin = nil
    latest = nil

    if v
      # Find the latest version that was in this state
      v.reverse.each do |ver|
        if (latest.nil? || latest.created_at.to_f<ver.created_at.to_f)
          latest = ver
        end
      end

      if latest
        # Find the originating version for the latest version
        curr = latest
        while curr && curr.state == latest.state
          # If no, previous version, then this is the origin
          # If the prvious version has the same state, then
          # this is not the origin for the transition
          # If the previos version has a differnt state, then
          # this is the origin for the transition
          if curr.previous.nil? ||  curr.state != curr.previous.state
            origin = curr
          end
          curr = curr.previous
        end # while curr

      end # if latest
    end # if v

    retval[:origin] = origin
    retval[:from] = origin.previous if origin

    retval[:latest] = latest
    retval[:to] = latest.next if latest

    retval

  end

  def transition_context(state=self.state)
    v = state_versions(state)
    self.class.transition_context(v)
  end

  def state_versions(state_sym)
    obj = self.reify
    if obj
      obj.versions.where(:state => state_sym.to_s)
    end
  end
end














# == Schema Information
#
# Table name: project_detail_versions
#
#  id         :integer         not null, primary key
#  item_type  :string(255)     not null
#  item_id    :integer         not null
#  event      :string(255)     not null
#  whodunnit  :string(255)
#  object     :text
#  created_at :datetime
#  state      :string(255)
#

