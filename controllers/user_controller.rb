require_relative '../models/user'
require_relative '../models/post'
require_relative '../models/comment'
require_relative '../models/hashtag'

class UserController
    attr_reader :db_client

    def initialize(db_client)
        @db_client = db_client
    end

    def create(data)
        if data.nil?
            return [ 400, 'missing data. please sure you already give username and email' ]
        end

        if data['username'].nil? or data['username'].empty? or data['email'].nil? or data['email'].empty?
            return [ 400, 'missing data. please sure you already give username and email' ]
        end

        username = data['username']
        email = data['email']
        bio = nil
        
        model = User.new(username, email, bio, nil, @db_client)
        created_id = model.save

        if created_id == 0
            return [ 406, "can't save data, maybe the data is already exist" ]
        end
        [ 201, {message: "new account is created", id: created_id }.to_json]
    end

    def update(id, data)
        username = data['username']
        bio = data['bio']

        model = User.new(username, nil, bio, id.to_i, @db_client)
        user_id = model.update

        if user_id <= 0
            return [404, "user not found"]
        end
        [200, {
            message: "data has been updated",
            username: username,
            bio: bio
    }.to_json]
    end

    def create_post(id, data)
        user_id = id.to_i

        content = data['content']
        attachment = data['attachment']
        data_post = nil
        
        # process the attachment
        unless attachment.nil?
            post = Post.new(content, attachment, user_id, @db_client)
            data_post = post.save
        else
            post = Post.new(content, nil, user_id, @db_client)
            data_post = post.save
        end

        user_name = @db_client.query("SELECT username FROM users WHERE id = #{user_id}").each[0]['username']

        hashtags = data['hashtags']
        hashtag_model = Hashtag.new(hashtags, @db_client)
        data_hashtags = hashtag_model.save

        data_hashtags.each do |tag|
            @db_client.query("insert into post_hashtags (post_id, hashtag_id) values (#{data_post['id']}, #{tag['id']})")
        end

        [
            201,
            {
                message: 'success create a post',
                user_id: user_id,
                user_name: user_name,
                post_id: data_post['id'],
                content: content,
                attachment: data_post['attachment'],
                tags: data_hashtags
            }.to_json
        ]
    end

    def create_comment(userId, postId, data)
        user_id = userId.to_i
        post_id = postId.to_i

        content = data['content']
        attachment = data['attachment']
        data_comment = nil

        # process the attachment
        unless attachment.nil?
            comment = Comment.new(content, attachment, post_id, user_id, @db_client)
            data_comment = comment.save
        else
            comment = Comment.new(content, nil, post_id, user_id, @db_client)
            data_comment = comment.save
        end

        user_name = @db_client.query("SELECT username FROM users WHERE id = #{user_id}").each[0]['username']

        hashtags = data['hashtags']
        hashtag_model = Hashtag.new(hashtags, @db_client)
        data_hashtags = hashtag_model.save

        data_hashtags.each do |tag|
            @db_client.query("insert into comment_hashtags (comment_id, hashtag_id) values (#{data_comment['id']}, #{tag['id']})")
        end

        [
            201,
            {
                message: 'success create a comment',
                user_id: user_id,
                user_name: user_name,
                comment_id: data_comment['id'],
                content: content,
                attachment: data_comment['attachment'],
                tags: data_hashtags
            }.to_json
        ]
    end
end