module ApplicationHelper
  def title(t)
    @title = t
  end

  def title_suffix
    APP_CONFIG["title_suffix"]
  end

  def h1
    @title
  end

  def page_title
    !@title.nil? ? "#{@title} - #{title_suffix}" : title_suffix
  end

  def number_to_words(number, alt = false)
    words = alt ? I18n.t("number_words_alt") : I18n.t("number_words")
    words[number] ? words[number] : number.to_s
  end

  # Text only form style display of attribute
  # name can be defined in simple_form.labels yaml definitions or a string as fallback
  def show_attribute(name, value)
    content_tag(:div,
      content_tag(:div, raw(I18n.t("simple_form.labels.#{name}", default: name)) + ':', class: 'control-label') +
      content_tag(:div, raw(value), class: 'controls'),
      class: 'form-group')
  end
end
