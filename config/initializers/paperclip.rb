Paperclip.interpolates :entry_type do |attachment, style|
  attachment.instance.entry_type.constantize.table_name
end

Paperclip.interpolates :entry_id do |attachment, style|
  attachment.instance.entry_id
end

Paperclip.interpolates :mystyle  do |attachment, style|
  if style.to_s == "original"
    return ""
  else
    return style.to_s + '/'
  end
end