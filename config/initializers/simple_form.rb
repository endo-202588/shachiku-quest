SimpleForm.setup do |config|
  # Wrappers
  config.wrappers :tailwind, tag: 'div', class: 'mb-4', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label, class: 'block text-sm font-medium text-gray-700 mb-1'

    b.use :input, class: 'mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm'

    b.use :hint, wrap_with: { tag: 'p', class: 'mt-2 text-sm text-gray-500' }
    b.use :error, wrap_with: { tag: 'p', class: 'mt-2 text-sm text-red-600' }
  end

  # Default wrapper
  config.default_wrapper = :tailwind

  # Error notification
  config.error_notification_tag = :div
  config.error_notification_class = 'bg-red-50 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4'

  # Button
  config.button_class = 'btn'

  # Boolean
  config.boolean_style = :inline

  # Browser validations
  config.browser_validations = false
end
