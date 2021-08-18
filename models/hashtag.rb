class Hashtag
    def initialize(hashtags, db_client)
        @hashtags = hashtags
        @db_client = db_client
    end

    def valid_form?
        if @hashtags.instance_of? Array
            if !@hashtags.empty?
                return true
            end
        end
        false
    end

    def clean_hashtags
        cleaner_hashtags = []
        hashtags = @hashtags.map(&:downcase).uniq
        hashtags = hashtags.reject(&:empty?)
        hashtags.each do |tag|
            cleaner_hashtags.append(tag.delete(" \t\r\n"))
        end
        cleaner_hashtags
    end

    def save
        data = []
        if valid_form?
            hashtags = clean_hashtags
            hashtags.each do |tag|
                @db_client.query("insert into hashtags (tag, amount) values ('#{tag}', 1) on duplicate key update amount = values(amount) + 1")
                temp = @db_client.query("select * from hashtags where tag = '#{tag}'").each[0]
                data.append(temp)
            end
        end
        data
    end

    def self.get_trending(db_client)
        data = db_client.query("select post_comment_hashtags.hashtag_id, hashtags.tag, count(hashtag_id) as amount from ( select hashtag_id, created_time from post_hashtags union all select hashtag_id, created_time from comment_hashtags where created_time > now() - interval 24 hour) as post_comment_hashtags join hashtags on post_comment_hashtags.hashtag_id = hashtags.id group by hashtag_id order by amount desc limit 5").each
        data
    end
end