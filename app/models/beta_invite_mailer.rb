class BetaInviteMailer < ActionMailer::Base
  def invite(inv)
    subject    'Beta Invite'
    recipients inv.email 
    from       'Blueberry Tree'
    sent_on    Time.now 
    
    body       :token=> inv.token 
  end
end
