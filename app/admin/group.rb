ActiveAdmin.register Group do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  
  index do 
    column :title
    column :user
    actions
  end
  
 show do |group|
      attributes_table do
        row :title
        row :created_at
        row :updated_at
      end
    panel "Users" do
      table_for group.users do
        column :username
        column :firstname
        column :lastname
        column :email
      end
    end
    active_admin_comments
  end
  
  permit_params :title, user_ids: []
  
  form do |f|
    f.inputs 'Details' do
      f.input :title, :as => :text
      f.input :users, as: :check_boxes, collection: User.all
    end
    
    f.actions
  end

end
