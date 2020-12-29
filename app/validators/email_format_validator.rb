# frozen_string_literal: true

class EmailFormatValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

  def validate_each(record, attribute, value)
    record.errors.add attribute, I18n.t('activemodel.validators.email_format.not_valid') unless
      value =~ EMAIL_REGEX
  end
end
