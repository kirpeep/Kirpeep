#require 'active_support/all'
module ApplicationHelper

	def sortable(column, title = nil)
		title   ||= column.titleize
		css_class = column == sort_column ? "current #{sort_direction}" : nil
		direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
		link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end

	def new_child_fields_template(form_builder, association, options = {})
	  options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
	  options[:partial] ||= association.to_s.singularize
	  options[:form_builder_local] ||= :f
	  content_for :jstemplates do
		content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
		  form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
		    render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
	      end
	    end
	  end
	end

	def add_offer_link(name, association)
	  link_to(name, "javascript:void(0)", :class => "add_child", :"data-association" => association)
	end

	def add_need_link(name, association)
	  link_to(name, "javascript:void(0)", :class => "add_child", :"data-association" => association)
	end

        


end
