require_relative '../models/hashtag'

class HashtagController
    def initialize(db_client)
        @db_client = db_client
    end

    def get_trending_tags
        data = Hashtag.get_trending(@db_client)
        [
            200,
            {trending_tags: data}.to_json
        ]
    end
end