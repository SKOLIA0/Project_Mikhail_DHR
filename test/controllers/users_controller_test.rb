require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      name: "Иван",
      surname: "Иванов",
      patronymic: "Иванович",
      email: "ivan@example.com",
      age: 25,
      nationality: "Русский",
      country: "Россия",
      gender: "male"
    )
  end

  test "should get index" do
    get users_path
    assert_response :success
    assert_select "h1", "Список пользователей" # проверяем, что заголовок отображается
  end

  test "should show user" do
    get user_path(@user)
    assert_response :success
    assert_select "h1", @user.full_name # проверяем, что имя пользователя отображается
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_path, params: { user: { name: "Петр", surname: "Петров", patronymic: "Петрович", email: "petr@example.com", age: 30, nationality: "Русский", country: "Россия", gender: "male" } }
    end
    assert_redirected_to users_path
  end

  test "should update user" do
    patch user_path(@user), params: { user: { email: "ivan_updated@example.com" } }
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal "ivan_updated@example.com", @user.email
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_path(@user)
    end
    assert_redirected_to users_path
  end
end
