class DiscountValidator < ActiveModel::Validator
 
  def validate(record)
    if record.obsolete? == true
      record.errors.add :base, 'You may not enter a discount that is superseded by an existing discount.'
    end
  end
end