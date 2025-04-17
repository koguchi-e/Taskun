class EventMailer < ApplicationMailer
    
  def send_notification(member, event)
    @group = event[:group]
    @title = event[:title]
    @date = event[:date]
    @body = event[:body]
    
    @mail = EventMailer.new()
    mail(
      from: ENV['MAIL_ADDRESS'],
      to:   member.email,
      subject: "#{@group.name} の新しいイベント通知"
    )
  end
  
  def self.send_notifications_to_group(event)
    group = event[:group]
    group.members.each do |member|
      EventMailer.send_notification(member, event).deliver_now
    end
  end
end
