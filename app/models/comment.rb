class Comment < ActiveRecord::Base
  attr_accessible :body, :post
  belongs_to :post
  
  #Add user Comment 
  belongs_to :user  
  validates :body, length: {minimum: 5}, presence: true 
  validates :user, presence: true 

  after_create :send_favorite_emails

  default_scope order("updated_at DESC")


  private

  def send_favorite_emails
    self.post.favorites.each do |favorite|
      if favorite.user_id != self.user_id && favorite.user.email_favorites?
        FavoriteMailer.new_comment(favorite.user, self.post, self).delvier
      end
    end
  end
end
