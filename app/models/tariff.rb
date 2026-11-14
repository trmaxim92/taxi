class Tariff < ApplicationRecord
  VALUE_TYPES = %w[percent fixed text].freeze

  validates :name, :value, :value_type, presence: true
  validates :value_type, inclusion: { in: VALUE_TYPES }
  validates :position, numericality: { only_integer: true }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :id) }

  def display_value
    case value_type
    when "percent"
      value.to_s.end_with?("%") ? value : "#{value}%"
    else
      value
    end
  end
end
