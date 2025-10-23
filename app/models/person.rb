class Person < Author
  validates :name, length: { minimum: 3, maximum: 80 }
  validates :birth_date, presence: true
  validate :birth_date_cannot_be_in_future

  private

  def birth_date_cannot_be_in_future
    return unless birth_date.present? && birth_date > Date.current
    errors.add(:birth_date, "cannot be in the future")
  end
end
