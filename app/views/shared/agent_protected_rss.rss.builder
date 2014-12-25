# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Project Blood Team : Agent ' + @agent.surname 
    xml.description " "
    xml.link agent_path(@agent, :format => :rss)

    for article in @feed do
      next if article.id.nil?
      mydesc = ''
      xml.item do
        xml.title "Protected entry."
        xml.description "This Project Blood Team agent protects their entries to only be visible to other PBT agents. Please contact the agent for their 'secret' RSS URL.", :type => "html"
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link "#{request.protocol}#{request.host_with_port}#{url_for(article)}"
        xml.guid "#{request.protocol}#{request.host_with_port}#{url_for(article)}"
       end
     end
  end
end