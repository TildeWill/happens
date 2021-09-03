class HistorizeService
  def self.update(object)
    object.class.transaction do
      new_content = object.dup
      new_content.save!
      new_content
    end
  end
end
