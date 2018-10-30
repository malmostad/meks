# Customized BS3 markup for symantic responsive forms
SimpleForm.setup do |config|
  config.default_wrapper = :basic
  config.label_class = nil
  config.error_notification_class = nil

  config.wrappers :basic, tag: 'div', class: 'form-group', error_class: 'warning' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'span', class: 'control-label' do |label|
      label.use :label
    end
    b.wrapper tag: 'div', class: 'controls' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :addon, tag: 'div', class: 'form-group addon', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'span', class: 'control-label' do |label|
      label.use :label
    end
    b.wrapper tag: 'div', class: 'controls input-group' do |ba|
      ba.use :input, class: 'form-control'
    end
    b.wrapper tag: 'div', class: 'controls input-group' do |ba|
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :datepicker, tag: 'div', class: 'form-group datepicker', error_class: 'warning' do |b|
    b.use :html5
    b.wrapper tag: 'span', class: 'control-label' do |label|
      label.use :label
    end
    b.wrapper tag: 'div', class: 'input-group date' do |ba|
      ba.use :input, class: 'form-control date', autocomplete: 'off'
    end
    b.wrapper tag: 'div', class: 'input-group' do |ba|
      b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      b.use :hint, wrap_with: { tag: 'p', class: 'help-block' }
    end
  end
end
