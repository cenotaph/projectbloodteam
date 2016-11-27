module EntryHelper
  
  def entry_agent_icon(entry)
    if entry.entry.nil?
      ''
    else
      image_tag entry.entry.agent_icon(:small)
    end
  end
  
  def entry_title(entry)
    (entry.entry.respond_to?('name') ? entry.entry.name : entry.entry.respond_to?('title') ? entry.entry.title : '')
  end
  
  def remove_from_newsfeed(entry)
    if agent_signed_in? 
      if entry.agent == current_agent
        link_to image_tag('/img/overlay/close.png', :width => 20), entry, :method => :delete, :data => {:confirm => 'Are you sure you want to remove this from the newsfeed?' }
      end
    end
  end
  
end