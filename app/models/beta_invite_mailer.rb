class BetaInviteMailer < ActionMailer::Base
  def invite(inv)
    subject    'BlueberryTree Beta Invite'
    recipients inv.email 
    from       '<Francisco> beta@blueberrytree.ws'
    sent_on    Time.now 
    
    body       :token=> inv.token 
  end
end
