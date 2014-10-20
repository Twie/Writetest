module GroupsHelper

  def twitter_text(group)
    url = result_group_url(group)
    result = @group.sentences.map(&:content).join('. ')
    final_len = 140 - url.length
    truncate(result,:length => final_len)  
  end
end