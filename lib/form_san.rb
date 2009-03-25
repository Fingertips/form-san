require 'action_view/helpers'

module FormSan
  # = FormSan::FormBuilder
  # 
  # FormSan has two goals:
  # * Make it easier for the developer to write out a form
  # * Make the resulting form more usable
  #
  # You can use the form builder by specifying it in the <tt>:builder</tt> option in <tt>form_for</tt>.
  #
  #   form_for(@post, :builder => FormSan::FormBuilder)
  #
  # You can also make it the default form builder by specifying it in an initializer or <tt>environment.rb</tt>.
  #
  #   ActionView::Base.default_form_builder = FormSan::FormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template
    delegate :concat, :content_tag, :to => :template
    
    # Wraps its content in a div with a fieldset class. You use it to group sets of fields.
    #
    #   <% f.fieldset do %>
    #     <p>Please complete the form.</p>
    #     …
    #   <% end %>
    #
    # Generates
    #
    #   <div class="fieldset">
    #     <p>Please complete the form.</p>
    #     …
    #   </div>
    def fieldset(&block)
      content_tag(:div, :class => 'fieldset', &block)
    end
    
    # Wraps its content in a div with a fields class. You use it to group fields.
    #
    #   <% f.fields do %>
    #     <h4>Personal information</h4>
    #     …
    #   <% end %>
    #
    # Generates
    #
    #   <div class="fields">
    #     <h4>Personal information</h4>
    #     …
    #   </div>
    def fields(&block)
      content_tag(:div, :class => 'fields', &block)
    end
    
    # Generates a short sentence in a paragraph describing which attributes have validation errors.
    #
    #   <% f.error_messages %>
    #
    # Generates something like
    #
    #   <p class="errors">Sorry, there were problems with the title, published date, and description.</p>
    def error_messages
      unless @object.errors.count.zero?
        attributes_with_errors =  @object.errors.map { |attribute, _| attribute } - ['base']
        content_tag(:p, :class => 'errors') do
          if attributes_with_errors.size > 1
            concat "Sorry, there were problems with the #{attributes_with_errors.to_sentence}."
          elsif attributes_with_errors.size == 1
            concat "Sorry, there was a problem with the #{attributes_with_errors.first}."
          else
            concat "#{@object.class} #{@object.errors.on(:base)}."
          end
        end
      else
        ''
      end
    end
    
    # Generates a short in a paragraph with the validation error of a specific attribute.
    #
    #   <% f.error_message(:title) %>
    #
    # Generates something like
    #
    #   <p class="notice">Can't be blank</p>
    def error_message(attribute)
      unless @object.errors.on(attribute).blank?
        content_tag(:p, :class => 'notice') do
          concat ERB::Util.html_escape(@object.errors.on(attribute).mb_chars.capitalize)
        end
      else
        ''
      end
    end
    
    def wrapped_label(attribute, *args)
      options = args.extract_options!
            
      label_text = args.first || attribute.to_s.humanize
      label_text << ' <span>(optional)</span>' if options[:optional]
      
      content_tag(:div, :class => 'label') do
        concat label(attribute, label_text)
      end
    end
    
    def field_with_extra_content(attribute, extra_content=nil, *args)
      options = args.extract_options!
      classes = @object.errors.on(attribute) ? 'invalid field' : 'field'
      
      content_tag(:div, :class => classes) do
        concat wrapped_label(attribute, args.first, :optional => options.delete(:optional))
        
        case input_type = options.delete(:type).to_s
        when 'textarea'
          concat ActionView::Helpers::InstanceTag.new(@object_name, attribute, self, @object).to_text_area_tag(options)
        else
          concat ActionView::Helpers::InstanceTag.new(@object_name, attribute, self, @object).to_input_field_tag(input_type, options)
        end
        
        concat error_message(attribute)
        concat extra_content unless extra_content.blank?
        @template.output_buffer # The block needs to return the current buffer
      end
    end
    
    def field(attribute, *args, &block)
      if block_given?
        concat field_with_extra_content(attribute, @template.capture(&block), *args)
      else
        field_with_extra_content(attribute, nil, *args)
      end
    end
  end
end

class ActionView::Helpers::InstanceTag
  def error_wrapping(html_tag, has_error)
    html_tag
  end
end