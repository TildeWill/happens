module FurcateModel
  class UpdateImmutableModelException < Exception
    def initialize(msg)
      super("Immutable model can't be updated. Use the #{HistorizeService.class.name} instead")
    end
  end

  extend ActiveSupport::Concern

  included do
    before_update :prevent_update
  end

  private

  def prevent_update
    raise UpdateImmutableModelException.new
  end
end
