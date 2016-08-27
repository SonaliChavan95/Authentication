ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "gmail.com",
    :user_name => "sample.kiprosh",
    :password => "salaryapp",
    :authentication => "plain",
    :enable_starttls_auto => true
}
