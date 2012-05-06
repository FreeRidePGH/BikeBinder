module PaperTrailContext

  # Given a metadata field for a papertrail model
  # Get all versions where the given metadata was updated
  def version_series(metadata_sym)
    v_series = []

    # Linear search
    self.versions.each do |ver|
      if ver.send(metadata_sym) != v_series.last.send(metadta_sym) 
        v_series << ver
      end
    end

    return v_series
  end

  # Given a metadata field, m, find the first version
  # that has a record matching value, val
  def originating_version(metadata_sym, val_str)
    self.versions.where(metadata_sym => val_str).first
  end

  # Given a metadata field, m, find the startpoint version
  # of the last record for metadata value
  def latest_version(metadata_sym, val_str)
    ver = self.versions.where(metadata_sym => val_str).last
    latest = startpoint_version(ver, metadata_sym, val_str)
  end

  # Given a metadata field, m,  and a version, v
  # Get the original version, v0, where m was saved into the version
  def startpoint_version(v, metadata_sym, val_str)
    origin = nil
    if (v && metadata)
      curr = d
      while curr && curr.send(metadata_sym) == val_str
        # If no, previous version, then this is the origin
        # If the prvious version has the same state, then
        # this is not the origin for the transition
        # If the previos version has a differnt state, then
        # this is the origin for the transition
        if curr.previous.nil? || curr.send(metadata_sym) != curr.previoius.send(metadata_sym)
          origin = curr
        end
        curr = curr.previous
      end
    end
    return origin
  end

  # Given a metadata field and a version
  # Get the last version, vn, where m was saved into the version
  def endpoint_version(v, m_sym)
    final = nil
    if (v && m_sym)
      # Find the endpoint version
      curr = v
      while curr && curr.send(m_sym) == final.send(m_sym)
        if curr.next.nil? ||  curr.send(m_sym) != curr.next.send(m_sym)
          final = curr
        end
        curr = curr.next
      end # while curr
    end
    return latest
  end
  
  # Given a metadata field and version
  # Get the originating version and the final version where m was saved
  def version_context(v)
    retval = {}
    
    
  end
  

end
