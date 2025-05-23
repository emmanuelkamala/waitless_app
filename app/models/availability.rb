class Availability < ApplicationRecord
  belongs_to :doctor

  validates :start_time, :end_time, presence: true
  validate :end_time_after_start_time

  scope :future, -> { where('start_time >= ?', Time.current) }

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end
end
