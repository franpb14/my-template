class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_one_attached :avatar

  def self.ransackable_attributes(_auth_object = nil)
    %w[name email created_at]
  end

  def name
    @name ||= self[:name].presence || email.split("@").first
  end

  protected

  def password_required?
    new_record? || password.present?
  end
end
