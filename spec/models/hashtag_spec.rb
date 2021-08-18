require_relative '../../models/hashtag'
require_relative '../../db/db_connector'

RSpec.describe 'hashtag model' do
    db_client = create_db_client

    before(:each) do
        client = create_db_client
        client.query('set foreign_key_checks = 0')
        client.query('truncate hashtags')
        client.query('truncate comment_hashtags')
        client.query('truncate post_hashtags')
        client.query('truncate comments')
        client.query('truncate posts')
        client.query('truncate users')
        client.query('set foreign_key_checks = 1')
    end
    
    describe '#save' do
        it 'should should save one hashtag' do
            hashtag = ['generasi']
            model = Hashtag.new(hashtag, db_client)

            stored_hashtag = model.save

            expect(stored_hashtag[0]['tag']).to eq('generasi')
        end

        it 'should save two hashtag' do
            hashtag = ['generasi', 'gigih']
            model = Hashtag.new(hashtag, db_client)

            stored_hashtag = model.save

            expect(stored_hashtag[0]['tag']).to eq('generasi')
            expect(stored_hashtag[1]['tag']).to eq('gigih')
        end

        it 'should save one hashtags because there is empty string' do
            hashtag = ['generasi', '']
            model = Hashtag.new(hashtag, db_client)

            stored_hashtag = model.save

            expect(stored_hashtag[0]['tag']).to eq('generasi')
            expect(stored_hashtag[1]).to be_nil
        end
    end

    describe '#get_trending' do
        it 'should return 5 top trending hashtags' do
            db_client.query("insert into users (username, email) values ('dio', 'dio@mail.com')")
            user_id = db_client.last_id
            db_client.query("insert into posts (content, user_id) values ('this is post', #{user_id})")
            post_id = db_client.last_id
            db_client.query("insert into comments (content, post_id, user_id) values ('this is comment', #{post_id}, #{user_id})")
            comment_id = db_client.last_id

            db_client.query("insert into hashtags (tag, amount) values ('generasi', 1) on duplicate key update amount = values(amount) + 1")
            tag_1 = db_client.last_id

            db_client.query("insert into hashtags (tag, amount) values ('gigih', 1) on duplicate key update amount = values(amount) + 1")
            tag_2 = db_client.last_id

            i = 0
            until i > 5 do
                db_client.query("insert into hashtags (tag, amount) values ('generasi', 1) on duplicate key update amount = values(amount) + 1")
                db_client.query("insert into post_hashtags (post_id, hashtag_id) values (#{post_id}, #{tag_1})")
                i += 1
            end

            i = 0
            until i > 3 do
                db_client.query("insert into hashtags (tag, amount) values ('gigih', 1) on duplicate key update amount = values(amount) + 1")
                db_client.query("insert into comment_hashtags (comment_id, hashtag_id) values (#{comment_id}, #{tag_2})")
                i += 1
            end

            trending_tag = Hashtag.get_trending(db_client)

            expect(trending_tag[0]['tag']).to eq('generasi')
            expect(trending_tag[0]['amount']).to eq(6)

            expect(trending_tag[1]['tag']).to eq('gigih')
            expect(trending_tag[1]['amount']).to eq(4)
        end
    end
    
end