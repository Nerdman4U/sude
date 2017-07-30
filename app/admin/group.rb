ActiveAdmin.register Group do
  permit_params :name, vote_proposal_ids: [], user_ids: []
  
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :name
      f.input :vote_proposals, :collection => VoteProposal.all.map { |vp|
        ["#{vp.topic}(#{vp.id})", vp.id]
      }
      f.input :users, :collection => User.all.map do |u|
        ["#{u.fullname}(#{u.username})", u.id]
      end
      f.actions
    end
  end

  show do
    attributes_table do
      row :name
      row :created_at
      row :updated_at

      row "Vote proposals" do
        group.vote_proposals.map(&:topic).join(", ")
      end
      row "Users" do
        group.users.map {|u| "#{u.fullname}(#{u.username})" }.join(", ") 
      end
    end
  end
  
  index do
    selectable_column
    column :name
    column :vote_proposals do |g|
      g.vote_proposals.map(&:topic).join(", ")
    end
    column :users do |g|
      g.users.map {|u| "#{u.fullname}(#{u.username})" }.join(", ")
    end
    actions
  end

end
