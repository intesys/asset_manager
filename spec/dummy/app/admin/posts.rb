ActiveAdmin.register Post do

  form :partial => 'form'

  show do
    panel "General" do
      attributes_table_for resource do
        row :id
        row :created_at
        row :updated_at
      end
    end
    panel "Post" do
      attributes_table_for resource do
        row :title
        row :sub_title
      end
    end
    if resource.class.medium?
      am = resource.class.medium_attributes
      panel "Medium" do
        attributes_table_for resource do
          am.each do |media|
            row media.to_sym
          end
        end
      end
    end
    if resource.class.media?
      am = resource.class.media_attributes
      panel "Media" do
        attributes_table_for resource do
          am.each do |media|
            row media.to_sym
          end
        end
      end
    end
  end
end
