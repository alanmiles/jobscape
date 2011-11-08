module ApplicationHelper

  def logo
    logo = image_tag("logo.png", :alt => "JobScape", :class => "round")
  end
  
  # Return a title on a per-page basis.
  def title
    base_title = "JobScape"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def two_dec(field)
    sprintf("%.2f", field)
  end
  
  def local_time_ago_in_words(time_str)
    time = time_str.to_time + (-Time.zone_offset(Time.now.zone))
    "#{time_ago_in_words(time)} ago"
  end
  
  def display_date(field)
    field.strftime("%b %d, %Y")
  end
  
  def display_daydate(field)
    field.strftime("%a %b %d, %Y")
  end
  
  def display_monthday(field)
    field.strftime("%b %d")
  end
end

