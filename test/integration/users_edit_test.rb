require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  test "setup" do
    @user = users(:vlas)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {name: '', email 'foo@invalid', password: 'foo', confirm_password: 'bar'}
    assert_template 'users/edit'
  end
end
