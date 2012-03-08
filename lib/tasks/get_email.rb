# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'mail'
require 'net/imap'

if false
Mail.defaults do
  retriever_method :pop3, :address    => "pop.gmail.com",
                          :port       => 995,
                          :user_name  => 'w090.001',
                          :password   => '11102008',
                          :enable_ssl => true
end

#emails = Mail.find(:what => :first, :count => 10, :order => :asc)
#puts emails.length #=> 10

unread_mail=Mail.first
unless unread_mail.blank?
  puts unread_mail.subject
  unread_mail=Mail.first
end
end


if false
Mail.all.each  do |mail|
 puts mail
 puts mail.subject
 puts mail.body
end


Mail.defaults do
  retriever_method :pop3, :address    => "pop.163.com",
                          :port       => 995,
                          :user_name  => 'w090_001@163.com',
                          :password   => 'followme123#',
                          :enable_ssl => true
end

unread_mail=Mail.first
unless unread_mail.blank?
  puts unread_mail.subject
  unread_mail=Mail.first
end
end

server = 'imap.gmail.com'
user = 'w090.001'
password = '11102008'
folder = 'INBOX'

imap = Net::IMAP.new(server, 993, true)
imap.login(user, password)
imap.select(folder)

imap.search(["NOT", "SEEN"]).each do |message_id|
 # envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
#   puts "#{envelope.from[0].name}: \t#{envelope.subject}"
  # puts "#{envelope.body}"
  mail = Mail.new(imap.uid_fetch(message_id, "RFC822")[0].attr["RFC822"])
  puts mail.subject
  puts mail.body.decoded
  #if mail.body.to_s.match("退信")
 #   puts "发现退信！！！"
 # end

 # imap.store(message_id, "+FLAGS", [:Seen])
end

imap.logout()
imap.disconnect()