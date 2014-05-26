# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Nix::Application.initialize!
require 'class_ext'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => "smtp.126.com",
    :port => 25,
    :domain => "126.com",
    :authentication => :login,
    :user_name => "kristy_yy@126.com",
    :password => "2311811"
}

ExceptionNotification::Notifier.exception_recipients = %w(234016483@qq.com)
ExceptionNotification::Notifier.email_prefix = "[ERROR] "
ExceptionNotification::Notifier.sender_address = %("Application Error" <system@iforce.com>)
