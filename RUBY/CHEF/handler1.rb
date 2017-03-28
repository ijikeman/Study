require 'chef/handler'

class MyClass < Chef::Handler
  def report
           message  = "From: Your Name <your@mail.address>\n"
           message << "To: Destination Address <someone@example.com>\n"
           message << "Subject: Chef Run #{@run_status}\n"
           message << "Date: #{Time.now.rfc2822}\n\n"
p message
  end
end

MyClass.new.run_report_safely(false)
