ActiveAdmin.register User do
  permit_params :username, :fullname, group_ids: [], vote_proposal_ids: [], vote_ids: []

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute  
    f.inputs :groups, as: :check_boxes, :collection => Group.all.map{ |group|
      [group.name, group.id]
    }
    f.inputs :vote_proposals, as: :check_boxes, :collection => VoteProposal.all.map{ |vp|
      [vp.topic, vp.id]
    }
    f.inputs :votes, as: :check_boxes, :collection => Vote.all.map{ |vote|
      [vote.id]
    }
    f.actions
  end

  show do
    attributes_table do
      row :username
      row :fullname
      row :status

      row "Vote proposals" do
        user.vote_proposals.map(&:topic).join(", ")
      end
      row "Groups" do
        user.groups.map {|g| "#{g.name}" }.join(", ") 
      end
    end
    panel "Votes" do
      user.votes.map do |vote|
        "#{vote.vote_proposal.topic}:#{vote.vote_proposal_options.map(&:name).join(", ")}"
      end    
    end
  end
  
  
  index do
    selectable_column
    column :username
    column :fullname
    column :status
    column :vote_proposals do |u|
      u.vote_proposals.map(&:topic).join(", ")
    end
    column :groups do |u|
      u.groups.map {|g| "#{g.name})" }.join(", ")
    end
    actions
  end

end
