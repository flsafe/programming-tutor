class BetaInviteMailer < ActionMailer::Base
  def invite(inv)
    subject    'Your BlueberryTree Beta Invite'
    recipients inv.email 
    from       'frank@cozysystems.com'
    sent_on    Time.now 
    body       :token=> inv.token 
  end
end
