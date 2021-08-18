require_relative '../models/post'

class PostController
    def initialize(db_client)
        @db_client = db_client
    end

    def get_post_for_hashtag(tag)
        data = Post.get_post_with_hashtag(tag, @db_client)
        [
            200,
            {posts: data}.to_json
        ]
    end
end