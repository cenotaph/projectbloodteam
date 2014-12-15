# -*- encoding : utf-8 -*-
module AgentsHelper
  
  def year_url_for_agent(item)
    if item.date.strftime('%Y') == Time.now.strftime("%Y")
      "/agents/#{item.agent_id.to_s}"
    else
      "http://#{item.date.strftime('%Y')}.bloodteam.com/agents/#{item.agent_id.to_s}"
    end
  end
  
end
