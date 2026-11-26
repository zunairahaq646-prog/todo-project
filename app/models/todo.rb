
class Todo < ApplicationRecord
  belongs_to :user

  validates :title, presence: true

  validates :status, inclusion: {
    in: %w[pending completed cancelled]
  }

  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= "pending"
  end
end
