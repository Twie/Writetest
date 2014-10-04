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
  
  permit_params :title, user_ids: []
  
  form do |f|
    f.inputs 'Details' do
      f.input :title, :as => :text
      f.input :users, as: :check_boxes, collection: User.all
    end
    # f.inputs do
        # f.has_many :users, :allow_destroy => true, :heading => 'users', :new_record => false do |cf|
          # cf.input :title
        # end
      # end
    
    f.actions
  end

end
