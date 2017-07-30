ActiveAdmin.register VoteProposal do
  permit_params :topic, :min_options, :max_options, :published_at, :viewable_at, vote_proposal_option_ids: [], user_ids: [], group_ids: []

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute  
    f.inputs :vote_proposal_options, as: :check_boxes, :collection => VoteProposalOption.all.map{ |option|
      [option.name, option.id]
    }
    f.inputs :users, as: :check_boxes, :collection => User.all.map{ |u|
      ["#{u.fullname}(#{u.username})", u.id]
    }
    f.inputs :groups, as: :check_boxes, :collection => Group.all.map{ |g|
      ["#{g.name}(id:#{g.id})", g.id]
    }
    f.actions
  end

  show do
    attributes_table do
      row :topic
      row :min_options
      row :max_options
      row :published_at
      row :viewable_at

      row "Vote proposal options" do
        vote_proposal.vote_proposal_options.map(&:name).join(", ")
      end
      row "Users" do
        vote_proposal.users.map {|u| "#{u.fullname}(#{u.username})" }.join(", ") 
      end
      row "Groups" do
        vote_proposal.groups.map {|u| "#{u.name}(id:#{u.id})" }.join(", ")
      end
    end
  end

  index do
    selectable_column
    column :topic
    column :min_options
    column :max_options
    column :published_at
    column :viewable_at
    column :vote_proposal_options do |vp|
      vp.vote_proposal_options.map(&:name).join(", ")
    end
    column :groups do |vp|
      vp.groups.map(&:name).join(", ")
    end
    column :users do |vp|
      vp.users.map {|u| "#{u.fullname}(#{u.username})" }.join(", ")
    end
    actions
  end
  
end
