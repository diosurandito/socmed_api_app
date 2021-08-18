class Comment
    def initialize(comment, attachment=nil, post_id, user_id, db_client)
        @comment = comment
        @attachment = attachment
        @post_id = post_id
        @user_id = user_id
        @db_client = db_client
    end

    def save
        @db_client.query("INSERT INTO comments (content, attachment, post_id, user_id) VALUES (\"#{@db_client.escape(@comment)}\", \"#{@attachment}\", #{@post_id}, #{@user_id})")
        id = @db_client.last_id
        data = @db_client.query("SELECT * FROM comments WHERE id = #{id}").each[0]
        data
    end
end