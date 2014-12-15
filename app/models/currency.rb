# -*- encoding : utf-8 -*-
class Currency < ActiveRecord::Base

  def long_name
    "#{name} (#{code}/#{symbol})".html_safe
  end
end
