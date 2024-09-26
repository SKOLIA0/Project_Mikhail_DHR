class Users::Create < ActiveInteraction::Base
  # Определяем параметры, которые будем принимать
  string :name
  string :surname
  string :patronymic
  string :email
  integer :age
  string :nationality
  string :country
  string :gender
  array :interests, default: []
  array :skills, default: []

  # Валидации для входных данных
  validates :name, :surname, :patronymic, :email, :age, :nationality, :country, :gender, presence: true
  validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
  validates :gender, inclusion: { in: %w[male female] }
  validate :email_must_be_unique

  # Основная бизнес-логика
  def execute
    # Формируем полное имя пользователя
    user_full_name = "#{surname} #{name} #{patronymic}"

    # Создаем пользователя с необходимыми параметрами
    user_params = inputs.except(:interests, :skills).merge(full_name: user_full_name)
    user = User.new(user_params)

    # Используем транзакцию для сохранения пользователя, интересов и навыков
    ActiveRecord::Base.transaction do
      user.save!
      assign_interests(user)
      assign_skills(user)
    end

    user
  rescue ActiveRecord::RecordInvalid => e
    errors.merge!(e.record.errors)
    nil
  end

  private

  # Проверка на уникальность email
  def email_must_be_unique
    errors.add(:email, 'уже существует') if User.exists?(email: email)
  end

  # Присваивание интересов пользователю
  def assign_interests(user)
    interest_records = Interest.where(name: interests)
    user.interests << interest_records
  end

  # Присваивание навыков пользователю
  def assign_skills(user)
    skill_records = Skill.where(name: skills)
    user.skills << skill_records
  end
end
