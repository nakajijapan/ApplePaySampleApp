require 'houston'

APN = Houston::Client.development
APN.certificate = File.read("./keys/development_net.nakajijapan.applepay.pem")

if ARGV[0].nil?
  p "please input token!"
  exit
end
token = ARGV[0]

notification = Houston::Notification.new(device: token)
notification.alert = "DeepLink"
notification.alert = "Push notification Test"

#notification.custom_data = {url: "http://www.google.com"}
notification.custom_data = {
  "aps": {
    "alert": {
      "body": "Test message!",
      "title": "Optional title"
    },
    "category": "payment"
  },
  "WatchKit Simulator Actions": [{
      "title": "Apple Pay",
      "identifier": "paymentButtonAction"
    }
  ]
}

APN.push(notification)

