Paperclip.interpolates :entry_type do |attachment, style|
  attachment.instance.entry_type.constantize.table_name
end

Paperclip.interpolates :entry_id do |attachment, style|
  attachment.instance.entry_id
end

Paperclip.interpolates :agent_id do |attachment, style|
  attachment.instance.agent_id
end

Paperclip.interpolates :year do |attachment, style|
  attachment.instance.year
end

Paperclip.interpolates :category do |attachment, style|
  attachment.instance.category
end



Paperclip.interpolates :mystyle  do |attachment, style|
  if style.to_s == "original"
    return ""
  else
    return style.to_s + '/'
  end
end
Paperclip::DataUriAdapter.register