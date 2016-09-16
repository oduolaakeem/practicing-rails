require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference("User.count") do
      post users_path, params: { user: {
        name: '',
        email: '',
        password: ''
        }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "not given password when signup" do
    get signup_path
    assert_no_difference("User.count") do
      post users_path, params: { user: {
        name: 'User',
        email: 'user@co.org',
        password: ''
        }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    # Check for duplicate error messages
    assert_select 'div#error_explanation li', {count: 1, text: "Password can't be blank"}
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: {
        name: 'User',
        email: 'user@example.com',
        password: 'password'
        }}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to login before activation
    log_in_as user
    assert_not is_logged_in?
    # Activation token is invalid
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?
    # Token is valid but wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # All valid
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    # Flash messag exists
    assert_not flash.empty?
    assert is_logged_in?
    # No errors shown
    divs = css_select 'div#error_explanation'
    assert_equal divs.length, 0
  end
end
