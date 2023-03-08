class DiscountValidator < ActiveModel::Validator
  def validate(record)
    return unless record.obsolete?

    record.errors.add :base, 'You may not enter a discount that is superseded by an existing discount.'
  end
end
