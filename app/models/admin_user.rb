
# == Schema Information
#
# Table name: admin_users
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#

class AdminUser < ActiveRecord::Base
end
