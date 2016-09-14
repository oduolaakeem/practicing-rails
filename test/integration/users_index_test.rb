require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @user = users(:archer)
  end

  test "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    assert_select 'ul.users li', count: 10
    assigns(:users).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference("User.count", -1) do
      delete user_path(@user)
    end
  end

  test "index as non-admin user" do
    log_in_as(@user)
    get users_path
    assert_select 'a', text: 'delete', count: 0 
  end
end
