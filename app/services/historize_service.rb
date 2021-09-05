class HistorizeService
  def self.update(object)
    object.class.transaction do
      new_content = object.dup
      #TODO: figure out where to insert/set the parent of the new leaf based on effective_on
      new_content.save!
      new_content
    end
  end
end
