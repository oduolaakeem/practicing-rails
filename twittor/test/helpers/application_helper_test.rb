require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         'Twittor'
    assert_equal full_title("Help"), 'Help | Twittor'
  end
end