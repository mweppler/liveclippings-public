
# == Schema Information
#
# Table name: stored_clippings
#
#  id          :integer(4)      not null, primary key
#  clipping_id :integer(4)      not null
#  content     :text            default(""), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class StoredClipping < ActiveRecord::Base

  belongs_to :clipping

  after_save :set_clipping_delta_flag

  # I get an error when this is uncommented...
  #validates :content, presence => true, :length => {:maximum => 65535}

  private

  def set_clipping_delta_flag
    clipping.delta = true
    clipping.save
  end
  
end
