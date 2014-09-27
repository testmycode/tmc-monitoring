
class Prober

  def submit_and_get_results(exercise_return_url: "", auth: {}, query: {}, poll_times: 10, sleep_time: 2)
    url = submit(exercise_return_url, auth, query)['submission_url']
    poll_submission(url, auth, poll_times, sleep_time)
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
  end


end

