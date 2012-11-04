class AddReviewerIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :reviewerID, :integer
  end
end
