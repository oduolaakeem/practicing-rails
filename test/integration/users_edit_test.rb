require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path @user
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {
      name: '',
      email: 'foo@bar',
      password: '123'
      }}
    assert_template 'users/edit'
    assert_select 'div.alert', { count: 1, text: /The form contains . errors/ }
    assert_select 'div#error_explanation li', 3
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path @user
    assert_template 'users/edit'
    name = 'mike'
    email = 'test@test.tw'
    patch user_path(@user), params: { user: {
      name: name,
      email: email,
      password: '' }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path @user
    assert_equal session[:forwarding_path], edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = 'mike'
    email = 'test@test.tw'
    patch user_path(@user), params: { user: {
      name: name,
      email: email,
      password: '' }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
