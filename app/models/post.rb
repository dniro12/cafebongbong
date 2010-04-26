class Post < ActiveRecord::Base
  belongs_to :User
  has_attached_file :avatar ,
        :styles => {:thumb => "75x75>", :small => "150x150>"}, 
        :storage => :s3, 
        :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
        :path => "/:style/:filename",
        :bucket => "cafebongbong"

    
  def Post.find_main_posts(args = { })
    sql = "select Posts.*, Users.* from posts inner join users on posts.name = users.name"
    find_by_sql(sql)
  end
  
end
