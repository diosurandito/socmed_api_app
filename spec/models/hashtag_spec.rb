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
    
end