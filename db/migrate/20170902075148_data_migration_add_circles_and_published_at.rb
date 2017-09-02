class DataMigrationAddCirclesAndPublishedAt < ActiveRecord::Migration[5.1]
  def up
    circle = Circle.new(name: "Yleiset asiat")
    circle.save
    VoteProposal.all.each do |vp|
      vp.published_at = Time.now - 3.days
      vp.circle = circle
      vp.save!
    end
  end
end
