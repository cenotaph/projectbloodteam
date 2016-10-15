# -*- encoding : utf-8 -*-
module ImageHelper

  def lightbox(item, images)
    out = '<div class="slick_carousel" id="' + item.class.to_s.downcase + "_" + item.id.to_s + '">'
    images.each do |i|
      out += '<div>'
      out += link_to image_tag(i, :alt => strip_tags(item.name)), i
      out += "</div>"
    end
    out += '</div>'

  end
  
  def one_or_slideshow(item, missing = '/system/no_image.png', style = nil, hide_master = false, rss = false)
    return '' if item.nil?
    if item.class.to_s =~ /Book$/ && style == :full
      style = :thumb
    end
    # figure out how many images there are
    imglist = []
    if item.has_master?
      if item.master.filename? 
        imglist.push item.master.icon unless hide_master == true
      end
    end
    if item.class.to_s =~ /^Master/
      if item.filename?
        imglist.push item.filename unless hide_master == true
      else
        imglist.push missing unless hide_master == true
      end
    end
    if item.respond_to?('userimages')
      if !item.userimages.blank?
        item.userimages.each do |ui|
          if ui.class == Userimage
            imglist.push ui.image.url(:fuller)
          else
            imglist.push ui.image.url
          end
        end
      end
    end

    if imglist.empty?
      return ""
    elsif imglist.size == 1
      if imglist.first.class == Paperclip::Attachment
        lightbox item, [imglist.first.url]
      else
        lightbox item, [imglist.first]
      end
    else
      return lightbox item, imglist
    end
  end
  

end
