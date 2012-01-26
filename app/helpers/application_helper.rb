module ApplicationHelper

  #def logo
  #  logo = image_tag("logo.png", :alt => "HYGWIT", :class => "round")
  #end
  
  # Return a title on a per-page basis.
  
  def title
    base_title = "HYGWIT"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def note_reference
    ref = 0
    unless @title.nil?
      @nt = Note.find_by_title(@title)
      unless @nt.nil?
        ref = @nt.id
      end
    end
    return ref
  end
  
  def note_title
    if note_reference == 0
      @content_header = "Guidance notes"
    else
      @result = Note.find(note_reference)
      @content_header = "Notes for '#{@result.title}'"
    end
  end
  
  def note_content
    if note_reference == 0
      @content_detail = "Sorry, there's no additional help for this page."
    else
      @result = Note.find(note_reference)
      @content_detail = simple_format(@result.content)
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
  
  def display_daymonthday(field)
    field.strftime("%a %b %d")
  end
  
end

