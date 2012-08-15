
# == Schema Information
#
# Table name: followings
#
#  user_id    :integer(4)
#  follow_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Following < ActiveRecord::Base

  belongs_to :user
  belongs_to :following, :class_name => "User", :foreign_key => "follow_id"

  validates_uniqueness_of :user_id, :scope => :follow_id, :message => "this relationship already exists..."
  validate :cannot_follow_yourself

  def cannot_follow_yourself
    if user_id == follow_id
      errors.add(:follow_id, "you cannot follow yourself.")
    end
  end

end
