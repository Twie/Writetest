ActiveAdmin.register BadWord do
  index do
    column :word
    actions
  end

  show do |group|
    attributes_table do
      row :word
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  permit_params :word

  form do |f|
    f.inputs 'Details' do
      f.input :word, :as => :text
    end

    f.actions
  end

end
