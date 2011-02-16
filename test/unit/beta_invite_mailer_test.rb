require 'test_helper'

class BetaInviteMailerTest < ActionMailer::TestCase
  test "invite" do
    @expected.subject = 'BetaInviteMailer#invite'
    @expected.body    = read_fixture('invite')
    @expected.date    = Time.now

    assert_equal @expected.encoded, BetaInviteMailer.create_invite(@expected.date).encoded
  end

end
