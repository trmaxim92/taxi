class Vehicle < ApplicationRecord
  validates :brand, :model, :slug, presence: true
  validates :slug, uniqueness: true
  validates :source, :verified_on, presence: true, if: :publishable?

  scope :published, -> { where(published: true) }
  scope :indexable, -> { published.where(is_indexable: true).where.not(source: [ nil, "" ]).where.not(verified_on: nil) }
  scope :ordered, -> { order(:position, :brand, :model) }
  scope :search, ->(q) {
    return all if q.blank?

    term = "%#{q.to_s.strip.downcase}%"
    where("LOWER(brand) LIKE :q OR LOWER(model) LIKE :q OR LOWER(CONCAT(brand, ' ', model)) LIKE :q", q: term)
  }
  scope :by_brand, ->(brand) {
    brand.present? ? where("LOWER(brand) = ?", brand.to_s.strip.downcase) : all
  }
  scope :by_year, ->(year) {
    return all if year.blank?

    y = year.to_i
    where("(year_from IS NULL OR year_from <= :y) AND (year_to IS NULL OR year_to >= :y)", y: y)
  }
  scope :by_tariff, ->(tariff) {
    return all if tariff.blank?

    where("LOWER(tariffs) LIKE ?", "%#{tariff.to_s.strip.downcase}%")
  }

  before_validation :generate_slug, if: -> { slug.blank? && brand.present? && model.present? }

  def to_param
    slug
  end

  def display_name
    "#{brand} #{model}"
  end

  def year_label
    return if year_from.blank? && year_to.blank?
    return year_from.to_s if year_to.blank? || year_to == year_from
    return "до #{year_to}" if year_from.blank?

    "#{year_from}–#{year_to}"
  end

  def tariff_list
    tariffs.to_s.split(/[,;]/).map(&:strip).reject(&:blank?)
  end

  def indexable?
    published? && is_indexable? && source.present? && verified_on.present?
  end

  def self.brand_options
    indexable.distinct.order(:brand).pluck(:brand)
  end

  def self.tariff_options
    indexable.pluck(:tariffs).flat_map { |t| t.to_s.split(/[,;]/) }.map(&:strip).reject(&:blank?).uniq.sort
  end

  private

  def publishable?
    published? && is_indexable?
  end

  def generate_slug
    self.slug = "#{brand}-#{model}".parameterize(locale: :ru)
  end
end
