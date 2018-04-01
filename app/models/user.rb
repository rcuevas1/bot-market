class User < ApplicationRecord
  validates_uniqueness_of :telegram_id
  has_many :jobs

  def set_next_bot_command(command)
    self.bot_command_data['command'] = command
    save
  end

  def get_next_bot_command
    bot_command_data['command']
  end

  def reset_next_bot_command
    self.bot_command_data = {}
    save
  end

  def get_unired_bot_response
    require "uri"
    require "net/http"

    params = {
      'apikey' => '5a5b950611aa4dfe8ec385e7c47cb1b3',
      'project' => '291591',
      'spider' => 'unired-one',
      'units' => '1',
      'user_id' => '17.085.922-7'
    }
    x = Net::HTTP.post_form(URI.parse('https://app.scrapinghub.com/api/run.json?apikey=5a5b950611aa4dfe8ec385e7c47cb1b3'), params)

    response_hash = JSON.parse x.body

    if response_hash["status"] == "ok"
      Job.create(user_id: self.id, shub_job_id: response_hash["jobid"])
    else
      puts "Something happend with this request :S"
    end
        
  end

end

#curl -u 5a5b950611aa4dfe8ec385e7c47cb1b3: https://app.scrapinghub.com/api/run.json -d project=291591 -d spider=unired-one -d units=2 -d user_id=17.085.922-7