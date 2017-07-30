ActiveAdmin.register Vote do
  permit_params :user_id, :vote_proposal_id, vote_proposal_option_ids: []
  
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :user, :collection => User.all.map { |u|
        [u.username, u.id]
      }
      f.input :vote_proposal, :collection => VoteProposal.all.map { |vp|
        [vp.topic, vp.id]
      }
      f.input :vote_proposal_options, :collection => VoteProposalOption.all.map { |op|
        [op.name, op.id]
      }
      f.actions
    end
  end
  
  show do
    attributes_table do
      row :user
      row :selected_options
      row :vote_proposal do
        vote.vote_proposal.topic
      end
      row "Vote proposal options" do
        vote.vote_proposal_options.map(&:name).join(", ")
      end
    end
  end

  index do
    selectable_column
    column :user
    column :selected_options
    column :vote_proposal do |vote|
      vote.vote_proposal.topic
    end
    column :vote_proposal_options do |vote|
      vote.vote_proposal_options.map(&:name).join(", ")
    end
    actions
  end
  
end
