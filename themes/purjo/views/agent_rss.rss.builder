# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Project Blood Team : Agent ' + @agent.surname 
    xml.description " "
    xml.link agent_path(@agent, :format => :rss)

    for article in @feed do
      mydesc = ''
      xml.item do
        if article.respond_to?('metadata') 
          article.metadata['metadata'].each_pair do |key, value|
            next if value.blank?
            mydesc += key.humanize + ": " + display_metadata(key, value)
            mydesc += "<br />"
          end
          mydesc += one_or_slideshow(article, nil, :full, false, true)
          mydesc += "<br />"
          mydesc += article.metadata['comment']
        end
          xml.title  article.class.to_s + ": " + article.name.gsub(/<\/?[^>]*>/,  "")
          xml.description mydesc, :type => "html"
          xml.pubDate article.created_at.to_s(:rfc822)
          xml.link "#{request.protocol}#{request.host_with_port}#{url_for(article)}"
          xml.guid "#{request.protocol}#{request.host_with_port}#{url_for(article)}"
       end
     end
  end
end