class Post
    def initialize(content, attachment=nil, user_id, db_client)
        @content = content
        @attachment = attachment
        @user_id = user_id
        @db_client = db_client
    end

    def save
        @db_client.query("INSERT INTO posts (content, attachment, user_id) VALUES (\"#{@db_client.escape(@content)}\", \"#{@attachment}\", #{@user_id})")
        id = @db_client.last_id
        data = @db_client.query("SELECT * FROM posts WHERE id = #{id}").each[0]
        data
    end

    def self.get_post_with_hashtag(tag, db_client)
        data = db_client.query("select posts.content, posts.attachment, posts.user_id, users.username, hashtags.tag, post_hashtags.created_time from posts join post_hashtags on posts.id = post_hashtags.post_id join hashtags on hashtags.id = post_hashtags.hashtag_id join users on posts.user_id = users.id where hashtags.tag=\"#{db_client.escape(tag)}\" order by post_hashtags.created_time desc;").each
        data
    end
end