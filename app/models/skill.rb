#Способ 1: Использовать алиас для модели
# Skill = Skil
#Способ 2: Переименовать модель Skil в Skill
class Skill < ApplicationRecord
  has_and_belongs_to_many :users
end
