module FurcateModel
  class UpdateImmutableModelException < Exception
    def initialize(msg)
      super("Immutable model can't be updated. Use the #{HistorizeService.class.name} instead")
    end
  end

  extend ActiveSupport::Concern

  included do
    has_ancestry

    scope :for, -> (date) { where("effective_on <= ?", date).order(effective_on: :desc) }

    before_create :tag_version_number
    before_update :prevent_update
  end

  private
  def tag_version_number
    self.version_identifier = SecureRandom.uuid unless self.version_identifier
  end

  def prevent_update
    raise UpdateImmutableModelException.new
  end
end
