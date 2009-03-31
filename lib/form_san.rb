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
    #   <%= f.error_messages %>
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
    #   <%= f.error_message(:title) %>
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
    
    def wrapped_label_with_extra_content(attribute, extra_content=nil, *args) #:nodoc:
      options = args.extract_options!
      
      label_text = args.first || attribute.to_s.humanize
      label_text << ' <span>(optional)</span>' if options[:optional]
      
      content_tag(:div, :class => 'label') do
        concat label(attribute, label_text)
        concat extra_content unless extra_content.blank?
        @template.output_buffer # The block needs to return the current buffer
      end
    end
    
    # Generates a label for an attribute wrapped in a div. It allows you to specify an alternative
    # humanized form of the attribute name and whether the associated field is optional or not.
    #
    #   <%= f.label(:title) %>
    #   <div class="label"><label for="book_title">Title</label></div>
    #
    #   <%= f.label(:title, 'Book title') %>
    #   <div class="label"><label for="book_title">Book title</label></div>
    #
    #   <%= f.label(:title, :optional => true) %>
    #   <div class="label"><label for="book_title">Title <span>(optional)</span></label></div>
    #
    # You can also pass a block to field, that way you can include more HTML into the div.
    #
    #   <% f.label(:year) do %>
    #     <span>(please fill out in YYYY format)</span>
    #   <% end %>
    #   <div class="label"><label for="book_title">Title <span>(optional)</span></label></div>
    def wrapped_label(attribute, *args, &block)
      if block_given?
        concat wrapped_label_with_extra_content(attribute, @template.capture(&block), *args)
      else
        wrapped_label_with_extra_content(attribute, nil, *args)
      end
    end
    
    def field_with_extra_content(attribute, extra_content=nil, *args) #:nodoc:
      options = args.extract_options!
      classes = @object.errors.on(attribute) ? 'invalid field' : 'field'
      
      content_tag(:div, :class => classes) do
        case input_type = options.delete(:type).to_s
        when 'textarea'
          wrapped_label(attribute, args.first, :optional => options.delete(:optional)) do
            concat error_message(attribute)
          end
          concat ActionView::Helpers::InstanceTag.new(@object_name, attribute, self, @object).to_text_area_tag(options)
        else
          concat wrapped_label(attribute, args.first, :optional => options.delete(:optional))
          concat ActionView::Helpers::InstanceTag.new(@object_name, attribute, self, @object).to_input_field_tag(input_type, options)
          concat error_message(attribute)
        end
        
        concat extra_content unless extra_content.blank?
        @template.output_buffer # The block needs to return the current buffer
      end
    end
    
    # Generates a field of a certain type wrapped in all sorts of HTML.
    #
    #   <%= f.field(:title, :type => :text) %>
    #   <div class="field">
    #     <div class="label"><label for="book_title">Title</label></div>
    #     <input id="book_title" type="text" name="book[title]" value="Empire of the Sun" />
    #   </div>
    #
    # When there is a validation error on the attribute, this will also be reflected in the HTML.
    #
    #   <div class="invalid field">
    #     <div class="label"><label for="book_title">Title</label></div>
    #     <input id="book_title" type="text" name="book[title]" value="" />
    #     <p class="notice">Can't be blank.</p>
    #   </div>
    #
    # You can also pass a block to field, that way you can include more HTML into the div.
    #
    #   <% f.field(:title, :type => :text) do %>
    #     <p class="note">This will be shown on the overview page as the book title.</p>
    #   <% end %>
    #
    #   <div class="field">
    #     <div class="label"><label for="book_title">Title</label></div>
    #     <input id="book_title" type="text" name="book[title]" value="Empire of the Sun" />
    #     <p class="note">This will be shown on the overview page as the book title.</p>
    #   </div>
    #
    # All options except <tt>:type</tt> are passed to the input.
    #
    #   <%= f.field(:title, :type => :text, :class => 'small') %>
    #
    #   <div class="field">
    #     <div class="label"><label for="book_title">Title</label></div>
    #     <input id="book_title" type="text" name="book[title]" value="Empire of the Sun" class="small" />
    #   </div>
    def field(attribute, *args, &block)
      if block_given?
        concat field_with_extra_content(attribute, @template.capture(&block), *args)
      else
        field_with_extra_content(attribute, nil, *args)
      end
    end
  end
end

module ActionView #:nodoc:
  module Helpers #:nodoc:
    class InstanceTag #:nodoc:
      def error_wrapping(html_tag, has_error)
        html_tag
      end
    end
  end
end