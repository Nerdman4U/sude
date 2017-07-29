# coding: utf-8
class DataMigration1 < ActiveRecord::Migration[5.1]
  def readCSV filename
    open(File.join(Rails.root,"test/data",filename)).readlines
  end
  def import table
    content = readCSV("#{table}.csv")
    header = content[0].split(",").map(&:strip)
    objects = content[1..-1]
    klass = table.classify.constantize
    objects.each do |object|
      obj = klass.create(header.zip(object.split(",").map(&:strip)).to_h)
      puts obj.errors.full_messages unless obj.valid?
    end
  end

  # CSV dump data is too slow, lets make faster solution
  def random_objects
    groups = Group.all
    users = User.all
    users.each do |user|
      user.group = groups.sample
      rand(1..10).times do |n| 
        VoteProposal.create(topic: "Äänestysehdotus #{n}")
      end
    end

    # Lets vote!    
    VoteProposal.all.each do |vp|
      votes = users.sample(rand(1..users.size))
      votes.each do |user|
        #user.vote(vp)
      end
    end
  end
  
  def up
    import("users")
    import("groups")
    import("vote_proposals")
    import("vote_proposal_options")
  end
  def down
    ActiveRecord::Base.connection.execute("DELETE FROM users; VACUUM")
    ActiveRecord::Base.connection.execute("DELETE FROM groups; VACUUM")
    ActiveRecord::Base.connection.execute("DELETE FROM vote_proposals; VACUUM")
    ActiveRecord::Base.connection.execute("DELETE FROM vote_proposal_options; VACUUM")
  end
end
