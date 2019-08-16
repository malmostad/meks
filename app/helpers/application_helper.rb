module ApplicationHelper
  def title(t)
    @title = t
  end

  def title_suffix
    APP_CONFIG['title_suffix']
  end

  def h1
    @title
  end

  def page_title
    !@title.nil? ? "#{@title} - #{title_suffix}" : title_suffix
  end

  def number_to_words(number, alt = false)
    words = alt ? I18n.t('number_words_alt') : I18n.t('number_words')
    words[number] ? words[number] : number.to_s
  end

  # Short form that takes arguments both in the
  # show_attribute and simple_attribute forms
  def kv(obj, *attr_chain)
    if obj.is_a? String
      show_attribute(obj, attr_chain.first)
    else
      simple_attribute(obj, *attr_chain)
    end
  end

  # Text only form style display of attribute
  # name can be defined in simple_form.labels yaml definitions or a string as fallback
  def show_attribute(name, value)
    content_tag(
      :div,
      content_tag(:div, raw(I18n.t("simple_form.labels.#{name}", default: name)) + ':', class: 'control-label') +
      content_tag(:div, raw(value), class: 'controls'),
      class: 'form-group'
    )
  end

  # show_attribute by chaining attributes to obj, e.g.
  # simple_attribute placement, :person, :name
  def simple_attribute(obj, *attr_chain)
    name = "#{obj.class.name.underscore}.#{attr_chain.map(&:to_s).join('.')}".gsub(/\.$/, '')
    value = attr_chain.inject(obj) { |o, a| o.send(a) }
    show_attribute(name, value)
  end

  # The key must be defined in info block in the simple_form locale file
  def popover(key)
    {
      title: I18n.t("simple_form.info.#{key}.title", default: nil),
      data: {
        create: :popover,
        content: I18n.t("simple_form.info.#{key}.content")
      }
    }
  end
end
