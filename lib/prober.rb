require 'json'
require 'pp'
require 'httmultiparty'

class Prober

  def initialize(opts = {})
    @exercise_return_url = opts[:exercise_return_url]
    @auth = opts[:auth]
    @query = opts[:query]
    @poll_times = opts[:poll_times]
    @sleep_time = opts[:sleep_time]
    @expected_results = opts[:expected_results]
  end

  def submit_and_validate()
    results = submit_and_get_results
    passed = []
    failed = []
    if results.nil?
      failed << "Results is nil"
    else
      @expected_results.each do |key, value|
        result = results[key] == value
        if result
          passed << "#{key} -> #{value}"
        else
          failed << "#{key} -> #{value} but was #{results[key]}"
        end
      end
    end
    [passed, failed, results]
  end

  def submit_and_get_results()
    url = submit(@exercise_return_url, @auth, @query)['submission_url']
    poll_submission(url, @auth, @poll_times, @sleep_time)
  end

  private

  def submit(url, auth, query)
    JSON.parse HTTMultiParty.post(url, basic_auth: auth, query: query).body
  end

  def poll_submission(url, auth, times, sleep_time)
    results = {}
    while(times > 0)
      results = JSON.parse HTTParty.get(url, basic_auth: auth).body
      if results['processing_time']
        return results
      end
      sleep(sleep_time)
      times -= 1
    end
    {timeout: {times: times, sleep_time: sleep_time}, url: url}
  end

  def to_s
    "#{@exercise_return_url}"
  end

end

