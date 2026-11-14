module ParkInfoHelper
  CONTACT_KEYS = %w[
    contact_phone
    contact_telegram
    contact_max
    contact_email
    self_register_url
  ].freeze

  LEGAL_KEYS = %w[
    legal_name
    legal_ogrn
    legal_inn
    legal_kpp
    legal_registered_on
  ].freeze

  COMMISSION_KEYS = %w[
    park_commission_percent
    withdrawal_fee_percent
  ].freeze

  def park_setting(key, default = "")
    SiteSetting.get(key, default).to_s.strip
  rescue StandardError
    default.to_s
  end

  def park_commission_percent
    park_setting("park_commission_percent", "2")
  end

  def withdrawal_fee_percent
    park_setting("withdrawal_fee_percent", "1")
  end

  def park_phone
    park_setting("contact_phone")
  end

  def park_telegram
    park_setting("contact_telegram")
  end

  def park_max
    park_setting("contact_max")
  end

  def park_email
    park_setting("contact_email")
  end

  def park_legal_name
    park_setting("legal_name", "ООО «СкайСкейл»")
  end

  def park_ogrn
    park_setting("legal_ogrn")
  end

  def park_inn
    park_setting("legal_inn")
  end

  def park_kpp
    park_setting("legal_kpp")
  end

  def park_registered_on
    park_setting("legal_registered_on")
  end

  def park_contacts?
    park_phone.present? || park_telegram.present? || park_max.present? || park_email.present?
  end

  def park_legal?
    park_ogrn.present? || park_inn.present? || park_kpp.present?
  end

  def self_register_url_value
    park_setting("self_register_url")
  end

  def self_register_href(city: nil, courier_type: nil)
    return self_register_url_value if self_register_url_value.present?

    go_register_path(city_id: city&.id, courier_type_id: courier_type&.id) if current_referral_link(city: city, courier_type: courier_type).present?
  end

  def self_register_external?
    url = self_register_url_value
    url.present? && url.match?(/\Ahttps?:\/\//i)
  end

  def telegram_href
    value = park_telegram
    return if value.blank?
    return value if value.match?(/\Ahttps?:\/\//i)

    handle = value.delete_prefix("@")
    "https://t.me/#{handle}"
  end

  def max_href
    value = park_max
    return if value.blank?
    return value if value.match?(/\Ahttps?:\/\//i)

    "https://max.ru/#{value.delete_prefix('@')}"
  end

  def phone_href
    return if park_phone.blank?

    "tel:#{park_phone.gsub(/[^\d+]/, '')}"
  end
end
