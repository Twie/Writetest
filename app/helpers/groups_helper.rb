module GroupsHelper

  def twitter_text(group)
    url = result_group_url(group)
    result = group.sentences.map(&:content).join('. ')
    final_len = 140 - url.length
    truncate(result,:length => final_len)
  end
  
  def groups_titles()
    group_titles_combo = Group.all.map(&:title).join(';')
  end
  
  def fb_text(group)
    result = group.sentences.map(&:content).join('. ')
    truncate(result,:length => 900)
  end
end