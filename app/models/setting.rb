# 'Inställningar'
# Simle key value settings
class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true, length: { maximum: 191 }
  validates :human_name, presence: true, length: { maximum: 191 }
  validates :value, presence: true, length: { maximum: 191 }
end
