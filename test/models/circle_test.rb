require 'test_helper'

class CircleTest < ActiveSupport::TestCase

  test 'should create a cirle and associate records to it' do
    parent = create(:circle)
    circle = create(:circle)

    # Associate parent circle
    #######################################################################
    circle.parent = parent
    assert circle.parent.circle == circle

    # Associate group
    #######################################################################
    group = create(:group)
    group.circles << circle    
    assert circle.group == group
    assert group.circles.include?(circle)

    group2 = create(:group)
    circle.group = group2
    assert circle.group == group2
    
    circle.save
    # After associating belongs_to record must be saved to make below
    # assertion work because association has required:false option...
    assert group2.circles.include?(circle)
    
    # Associate vote proposals
    #######################################################################
    vote_proposal = create(:vote_proposal)
    circle.vote_proposals << vote_proposal
    assert vote_proposal.circle == circle
    assert circle.vote_proposals.include?(vote_proposal)

    vote_proposal2 = create(:vote_proposal)
    vote_proposal2.circle = circle
    assert vote_proposal.circle == circle
    # This works because associations do not have any options
    assert circle.vote_proposals.include?(vote_proposal)
  end
  
end
