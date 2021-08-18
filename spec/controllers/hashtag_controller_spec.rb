require_relative '../../controllers/hashtag_controller'
require_relative '../../db/db_connector'

RSpec.describe 'hashtag controller' do
    db_client = create_db_client
    username = 'dio'
    email = 'dio@mail.com'
    bio = 'i am dio'
    content = 'nice day'
    tag = 'tags'

    query_insert_user = "insert into users (username, email, bio) values ('#{username}', '#{email}', '#{bio}')"
    query_insert_post = "insert into posts (content, user_id) values ('#{content}', 1)"
    query_insert_hashtag = "insert into hashtags (tag, amount) values ('#{tag}', 1)"
    query_insert_comment = "insert into comments (content, post_id, user_id) values ('#{content}', 1, 1)"
    query_post_hashtag = "insert into post_hashtags (post_id, hashtag_id) values (1, 1)"
    query_comment_hashtag = "insert into comment_hashtags (comment_id, hashtag_id) values (1, 1)"


    before(:each) do
        client = create_db_client
        client.query('set foreign_key_checks = 0')
        client.query('truncate users')
        client.query('truncate posts')
        client.query('truncate comments')
        client.query('truncate hashtags')
        client.query('truncate post_hashtags')
        client.query('truncate comment_hashtags')
        client.query('set foreign_key_checks = 1')
    end

    describe '#get_trending_tags' do
        it 'should return trending tags with amount from post_hashtags and comment_hashtags with response code 200' do
            db_client.query(query_insert_user)
            db_client.query(query_insert_post)
            db_client.query(query_insert_hashtag)
            db_client.query(query_insert_comment)
            db_client.query(query_post_hashtag)
            db_client.query(query_comment_hashtag)
            
            hashtag_controller = HashtagController.new(db_client)
            trending_tag = hashtag_controller.get_trending_tags

            expect(trending_tag[0]).to eq(200)
        end
    end

end