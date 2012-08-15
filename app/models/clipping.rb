
# == Schema Information
#
# Table name: clippings
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)      not null
#  url          :string(255)
#  title        :string(255)
#  summary      :string(255)
#  content_type :string(4)
#  read         :boolean(1)      default(FALSE)
#  favorite     :boolean(1)      default(FALSE)
#  archive      :boolean(1)      default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#  public       :boolean(1)      default(FALSE)
#  delta        :boolean(1)      default(TRUE), not null
#

require 'mechanize'

class Clipping < ActiveRecord::Base

  belongs_to :user
  has_one :stored_clipping
  accepts_nested_attributes_for :stored_clipping, :allow_destroy => true

  attr_accessor :page

  CONTENT_TYPES = ['html', 'text']

  validates_inclusion_of :content_type, :in => CONTENT_TYPES, 
    :message => "must be one of: #{CONTENT_TYPES.join(', ')}"
  validates :url, :presence => true, :length => {:maximum => 255}, :if => :type_is_html?
  validate :url_must_resolve_to_webpage, :if => :type_is_html?
  validates :title, :presence => true, :length => {:maximum => 255}
  validates :summary, :length => {:maximum => 255}
  validates_uniqueness_of :url, :scope => :user_id, :if => :type_is_html?, :message => "already exists."

  # Thinking Sphinx Index
  define_index do
    indexes title
    indexes stored_clipping.content, :as => :clipping_content
    indexes url
    has user_id, updated_at
    set_property :delta => true
    # where sanitize_sql(["user_id = ?", current_user.id])
  end

  def retrieve_html_content
    unless url.empty?
      begin
        if /http:\/\//.match(url).nil?
          if /https:\/\//.match(url).nil?
            url.insert(0, "http://")
          end
        end
        agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
        self.page = agent.get_file(url)
      rescue Mechanize::ResponseCodeError => error
        logger.error "#{url} does not resolve to a webpage: #{error.response_code} error"
      rescue Errno::ENOENT
        logger.error "No such file or directory"
      end
    end
  end

  def retrieve_body_from_html
    begin
      body_tag = /<body.*?>/i.match(self.page).to_s
      body_begin = self.page.index(body_tag) + body_tag.length
      body_end = self.page.rindex(/<\/body>/i) - 1
      body = self.page[body_begin..body_end]
    rescue
      #
    ensure
      if body.nil?
        body = ""
      end
    end
    return body
  end

  def retrieve_title_from_html
    begin
      title_tag = /<title.*?>/i.match(self.page).to_s
      title_begin = self.page.index(title_tag) + title_tag.length
      title_end = self.page.index(/<\/title>/i) - 1
      title = self.page[title_begin..title_end].strip
    rescue
      #
    ensure
      if title.nil?
        title = ""
      end
    end
    if title.size > 255
      title = title[0,254]
    end
    return title
  end

  private

  def type_is_html?
    content_type === 'html'
  end

  def url_must_resolve_to_webpage
    begin
      if /http:\/\//.match(url).nil?
      if /https:\/\//.match(url).nil?
        url.insert(0, "http://")
      end
      end
      agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
      self.page = agent.get_file(url)
    rescue Mechanize::ResponseCodeError => error
      errors.add(:url, "does not resolve to a webpage: #{error.response_code} error")
    rescue Errno::ENOENT
      errors.add(:url, "does not resolve to a webpage.")
    end
  end

end
