require 'json'
require 'pp'
require 'httmultiparty'
require_relative 'mailer'
class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end

class Monitor

  def initialize(opts = {})
    @monitors = []
    @passed = {}
    @failed = {}
    @results = {}
    @notify_emails = opts[:notify_emails]
  end

  def add_monitor(opts = {})
    @monitors << Prober.new(opts)
  end


  def monitor
    @monitors.each do |monitor|
      passed, failed, results = monitor.submit_and_validate
      @passed[monitor] = passed
      @failed[monitor] = failed
      @results[monitor] = results
    end

    print_results
    send_alert generate_results.gsub("\n", "<br />")
  end

  def send_alert(body)
    @notify_emails.each do |email|
      Mailer.alert(email, body).deliver
    end
  end

  def generate_results
    result = []
    result << "PASSED"
    @passed.each do |monitor, results|
      result << "  #{monitor}"
      results.each do |res|
        result << "    #{res}"
      end
    end
    result << "FAILURES"
    @failed.each do |monitor, results|
      result << "  #{monitor}"
      results.each do |res|
        result << "    #{res}"
      end
    end
    if @failed.any?
      result <<  JSON.pretty_generate(@results)
    end
    result.join("\n").gsub(" ", "&nbsp;")
  end

  def print_results
    puts "PASSED".green
    @passed.each do |monitor, results|
      puts "  #{monitor}".green
      results.each do |result|
        puts "    #{@green}#{result}#{@clear}".green
      end
    end
    puts "FAILURES".red
    @failed.each do |monitor, results|
      puts "  #{monitor}".red
      results.each do |result|
        puts "    #{@red}#{result}#{@clear}".red
      end
    end
    if @failed.any?
      puts JSON.pretty_generate(@results).red
    end
  end

end
