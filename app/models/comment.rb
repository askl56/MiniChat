class Comment < ActiveRecord::Base
  belongs_to :user
  validates :body, presence: true, length: {maximum: 2000}
  after_create :notify_comment_added

  def timestamp
    created_at.strftime('%-d %B %Y, %H:%M:%S')
  end

  class << self
    def remove_excessive!
      if all.count > 100
        order('created_at ASC').limit(all.count - 50).destroy_all
      end
    end

    def on_change
      Comment.connection.raw_connection.wait_for_notify do |event, pid, comment|
        yield comment
      end
    end

  ensure
    Comment.connection.execute "UNLISTEN comments"
  end

  private

  def notify_comment_added
    Comment.connection.execute "NOTIFY comments, 'data'"
  end
end
