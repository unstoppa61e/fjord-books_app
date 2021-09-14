class CreatedAtValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    current_time = Time.zone.now
    from = current_time.beginning_of_day
    to = current_time.end_of_day
    record.errors[attribute] << ': 同じ日付の日報は既に存在します' if Report.where(created_at: from..to).exists?
  end
end
