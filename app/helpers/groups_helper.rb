require 'open-uri'
module GroupsHelper

  def twitter_text(group)
    url = result_group_url(group)
    result = group.sentences.map(&:content).join('. ')
    final_len = 140 - url.length
    result = truncate(result,:length => final_len).to_str
    URI::encode(result)
  end
  
  def groups_titles()
    group_titles_combo = Group.all.map(&:title).join(';')
  end
  
  def fb_text(group)
    result = group.sentences.map(&:content).join('. ')
    result = truncate(result,:length => 900).to_str
    URI::encode(result)
  end
end