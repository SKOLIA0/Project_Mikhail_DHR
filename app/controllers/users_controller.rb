class UsersController < ApplicationController
  # Отображает список всех пользователей
  def index
    @users = User.all
  end

  # Показывает форму для создания нового пользователя
  def new
    @user = User.new
  end

  # Создает нового пользователя
  def create
    user_params = params.require(:user).permit(:name, :surname, :patronymic, :email, :age, :nationality, :country, :gender, :interests, :skills)

    # Разбиваем введенные значения для интересов и навыков, обрабатывая nil
    interests = user_params[:interests].present? ? user_params[:interests].split(',').map(&:strip).map { |name| Interest.find_or_create_by(name: name) } : []
    skills = user_params[:skills].present? ? user_params[:skills].split(',').map(&:strip).map { |name| Skill.find_or_create_by(name: name) } : []

    # Создаем нового пользователя
    @user = User.new(user_params.except(:interests, :skills))
    @user.interests = interests
    @user.skills = skills

    # Сохраняем пользователя, если валидации прошли успешно
    if @user.save
      redirect_to users_path, notice: 'Пользователь успешно создан'
    else
      # Если валидация не удалась, снова рендерим форму с ошибками
      render :new, status: :unprocessable_entity
    end
  end

  # Показывает одного пользователя
  def show
    @user = User.find(params[:id])
  end

  # Показывает форму для редактирования существующего пользователя
  def edit
    @user = User.find(params[:id])
  end

  # Обновляет данные пользователя
  # Обновляет данные пользователя
  def update
    @user = User.find(params[:id])  # Загружаем пользователя

    user_params = params.require(:user).permit(:name, :surname, :patronymic, :email, :age, :nationality, :country, :gender, :interests, :skills)

    interests = user_params[:interests].present? ? user_params[:interests].split(',').map(&:strip).map { |name| Interest.find_or_create_by(name: name) } : []
    skills = user_params[:skills].present? ? user_params[:skills].split(',').map(&:strip).map { |name| Skill.find_or_create_by(name: name) } : []

    if @user.update(user_params.except(:interests, :skills))
      @user.interests = interests
      @user.skills = skills
      redirect_to @user, notice: 'Пользователь успешно обновлен'  # Перенаправление на страницу конкретного пользователя
    else
      render :edit
    end
  end



  # Удаляет пользователя
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'Пользователь успешно удален'
  end

  private

  # Разрешенные параметры для пользователя
  def user_params
    params.require(:user).permit(
      :name, :surname, :patronymic, :email, :age,
      :nationality, :country, :gender,
      interests: [], skills: []
    )
  end
end
