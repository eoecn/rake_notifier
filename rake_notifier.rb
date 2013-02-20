require 'pony'

module Rake
  mattr_accessor :email_from, :email_to

  class Application
    def standard_exception_handling
      begin
        yield
      rescue Exception => e
        handle_exception(e)
        exit(false)
      end
    end

    def handle_exception(exception)
      if Rake.email_from.blank? # lazy load
        # fetch emails from ExceptionNotifier's configuration
        if defined? ExceptionNotifier
          args = Rails::Application.subclasses.map {|app| app.config.middleware.middlewares }.flatten.select {|m| m === ExceptionNotifier }.map {|en| en.args }.flatten
          if args.blank?
            raise "Please setup your ExceptionNotifier first"
          else
            Rake.email_from = args[0][:sender_address]
            Rake.email_to   = args.map {|i| i[:exception_recipients] }.flatten.join(", ")
          end
        end
      end

      $stderr.puts "#{name} aborted!"
      $stderr.puts exception.message
      $stderr.puts exception.backtrace.join("\n")

      # Send email
      subject = "Rake exception - #{exception.message}"
      body = "#{exception.message}\n\n#{exception.backtrace.join("\n")}"

      Pony.mail(:to => Rake.email_from, :from => Rake.email_to, :subject => subject, :body => body)

      $stderr.puts
      $stderr.puts
      $stderr.puts "Exception details sent to #{EMAIL_TO}"
    end
  end
end
