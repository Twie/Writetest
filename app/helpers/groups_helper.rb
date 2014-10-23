require 'open-uri'
module GroupsHelper

  def twitter_text(group)
    url = result_group_url(group)
    result = group.sentences.map(&:content).join('. ')
    final_len = 140 - url.length
    puts result.class
    result = truncate(result,:length => final_len).to_str
    puts result.class
    URI::encode(result)
  end
  
  def groups_titles()
    group_titles_combo = Group.all.map(&:title).join(';')
  end
  
  def fb_text(group)
    result = group.sentences.map(&:content).join('. ')
    puts result
    puts result.class
    result = truncate("amrata",:length => 900).to_str
    puts result.class
    URI::encode(result)
  end
end