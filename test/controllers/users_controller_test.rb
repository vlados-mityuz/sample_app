require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:vlas)
  end

  test "should get new" do
    get users_new_url
    assert_response :success
  end

  test "should redirect edit when not logged_in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged_in" do
    patch :update, id: @user, user: {name = @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
