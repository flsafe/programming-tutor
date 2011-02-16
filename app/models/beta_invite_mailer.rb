class BetaInviteMailer < ActionMailer::Base
  def invite(inv)
    subject    'BetaInviteMailer#invite'
    recipients inv.email 
    from       'Blueberry Tree'
    sent_on    Time.now 
    
    body       :greeting => 'Your Blueberry Invite'
  end
end
