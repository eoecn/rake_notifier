require 'pony'
require 'rake/task'

# load only_one_rake.gem first, because it'll overwrite Rake::Task#execute directly
require 'only_one_rake'

module Rake
  mattr_accessor :email_from, :email_to

  class Task
    alias :orig_execute :execute
    def execute(args=nil)
      orig_execute(args)
    rescue Exception => exception
      handle_exception(exception)
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

      $stderr.puts
      $stderr.puts subject = "Rake exception - #{exception.message}"
      $stderr.puts body = "#{exception.message}\n\n#{exception.backtrace.join("\n")}"
      Pony.mail(:from => Rake.email_from, :to => Rake.email_to, :subject => subject, :body => body)
      $stderr.puts
      $stderr.puts "Exception details sent to #{Rake.email_to}"
      $stderr.puts
    end
  end
end
