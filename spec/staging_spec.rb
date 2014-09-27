require 'spec_helper'

describe 'staging' do


  let(:prober) {Prober.new}
  it 'works' do

    exercise_return_url = 'https://tmc.mooc.fi/staging/exercises/839/submissions.json'
    auth = {username: ENV['USERNAME'], password: ENV['PASSWORD']}
    query = {
      api_version: 7,
        submission: {file: File.new('arith_funcs_solutions.zip')}
      }
    poll_times = 10
    sleep_time = 2

    results = prober.submit_and_get_results(exercise_return_url: exercise_return_url, auth: auth, query: query, poll_times: poll_times, sleep_time: sleep_time)

    results['all_tests_passed'].should_be true

  end


# url
# credentials
# file
# result hash
#   key, expected value / json
# attempts
# sleep_time
# escalation_emails
#
  end
