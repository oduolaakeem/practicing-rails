require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

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

  test "valid signup information" do
    get signup_path
    assert_difference("User.count", 1) do
      post users_path, params: { user: {
        name: 'User',
        email: 'user@example.com',
        password: 'password'
        }}
    end
    follow_redirect!
    assert_template 'users/show'
    # No errors shown
    divs = css_select 'div#error_explanation'
    assert_equal divs.length, 0
    # Flash messag exists
    assert_not flash.empty?
    assert is_logged_in?
  end
end
