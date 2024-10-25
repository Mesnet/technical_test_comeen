# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  has_many :desk_bookings, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
