require 'rubygems'
require 'bundler'
Bundler.require(:default)

require_relative 'lib/monitor'
require_relative 'lib/prober'

## Sample configuration

monitor = Monitor.new({notify_emails: ["jamo@isotalo.fi"]})

monitor.add_monitor({
  exercise_return_url: 'https://tmc.mooc.fi/staging/exercises/839/submissions.json',
  auth: {username: ENV['USERNAME'], password: ENV['PASSWORD']},
  query: {
    api_version: 7,
    submission: {file: File.new('arith_funcs_solutions.zip')}
  },
  poll_times: 10,
  sleep_time: 2,
  expected_results: {
    "all_tests_passed"=>true,
    "course"=>"jamo_demo",
    "exercise_name"=>"arith_funcs",
    "status"=>"ok",
    "points"=>["arith-funcs", "ei ole"],
  }
})


monitor.monitor
