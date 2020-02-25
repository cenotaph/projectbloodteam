module ApplicationHelper

  def getYear
    year = request.domain(2)

    if !year.nil? && year.split('.').first =~ /^\d\d\d\d$/
      return year.split('.').first
    else
      return Time.now.strftime('%Y')
    end
  end


  def display_column(item, column, agent = nil)
    unless ['id', 'created_at', 'updated_at', 'agent_id', 'venue_address'].include?(column)
      # date
      if item[column.to_sym].class == Date || column == :created_at
        if agent.nil?
          item[column.to_sym].strftime('%D')
        else
          df = Profile.where(:agent_id => agent).where(:year =>  item[column.to_sym].strftime('%Y')).first
          df.nil? ? item[column.to_sym].strftime('%D') : item[column.to_sym].strftime(df.dateformat)
        end
      elsif item[column.to_sym].class == TrueClass
        'yes'
      elsif item[column.to_sym].class == FalseClass
        'no'
      elsif column == 'cost'
        number_to_currency(item[column.to_sym], :unit => ( item.currency_id.blank? ? '$' : Currency.find(item.currency_id).symbol).html_safe, :format => ( item.currency_id.blank? ? "%u%n" : ( (Currency.find(item.currency_id).unitafter == true ) ? "%n%u" : "%u%n")))
      else
        if (column == 'location' || column == 'venue') and item.respond_to?('venue_address')
          if item['venue_address'].blank?
            raw(item.send(column))
          elsif item.send(column).nil?
            raw item['venue_address']
          else
            raw(item.send(column) + "<div class='venue_address'>#{item['venue_address']}</div>")
          end
        else
          item.send(column) #[column.to_sym])
        end
      end
    end
  end

  def display_comment(item)
    if item.class == Comment
       sanitize item.content , tags:  %w{b i em italic embed iframe div bold strong a u  br p src ol li ul img}, attributes: %w{href src height class width}
    else
      item.comment.blank? ? '<em>No comment yet.</em>' :  sanitize(item.comment.gsub(/\<br\/*\>/, '<br /><br />').gsub(/^<p>/i, '').gsub(/\n/, '<br />'), tags:  %w{b i em italic bold strong a u br p ol li ul img}, attributes: %w{href})
    end
  end

  def display_metadata(key, value)

    if key == 'cost'
      if value.last.blank?
        ""
      else
        number_to_currency(value.last, :unit => value.first.nil? ? '$' : Currency.find(value.first).symbol.html_safe, :format => ( (Currency.find(value.first).unitafter == true ) ? "%n%u" : "%u%n"))
      end
    elsif value.nil?
      ""
    elsif value == true
      "yes"
    elsif value == false
      "no"
    elsif value.class == Date
      if agent_signed_in?
        value.strftime(current_agent.profile.dateformat) rescue value.strftime('%B %e, %Y')
      else
        value.strftime('%B %e, %Y')
      end
    else
      value.to_s
    end
  end


  def show_entry?(entry)
    case entry.agent.security
      when 0
        return true
      when 1
        return true
      when 2
        return true if agent_signed_in?
      when 3
        if agent_signed_in?
          if current_agent == entry.agent
            return true
          else
            return false
          end
        else
          return false
        end
      else
        return false
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render('shared/' + association.to_s.singularize + "_fields", :ff => builder)
    end
    link_to(name, ("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :remote => true)
  end


  def pageless(total_pages, url=nil)
      opts = {
        :totalPages => total_pages,
        :url        => url,
        :loaderMsg  => 'Loading more results',
        :loaderImage => '/img/icons/load.gif'
      }

      javascript_tag("$('#results').pageless(#{opts.to_json});")
    end



end
