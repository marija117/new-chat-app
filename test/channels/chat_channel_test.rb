require "test_helper"

class ChatChannelTest < ActionCable::Channel::TestCase
  # test "subscribes" do
  #   subscribe
  #   assert subscription.confirmed?
  # end

  def test_connects_with_proper_cookie
    # Simulate the connection request with a cookie.
    cookies["user_id"] = users(:john).id

    connect

    # Assert the connection identifier matches the fixture.
    assert_equal users(:john).id, connection.user.id
  end

  def test_rejects_connection_without_proper_cookie
    assert_reject_connection { connect }
  end

end
