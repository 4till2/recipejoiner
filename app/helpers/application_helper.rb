module ApplicationHelper
  def link_to_add_fields(name, form, association)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render("#{association.to_s.singularize}_field", f: builder)
    end
    link_to(name, '#',
            class: 'my-3 py-2 px-3 bg-gray-100 rounded-full text-gray-400 hover:text-gray-600 cursor-pointer flex text-center',
            data: { action: 'nested-form#addField', id: id, fields: fields.gsub("\n", '') })
  end
end
