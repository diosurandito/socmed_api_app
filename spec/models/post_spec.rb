require_relative '../../models/post'
require_relative '../../db/db_connector'

RSpec.describe 'post model' do
    db_client = create_db_client
    query_insert_user = "INSERT INTO users (username, email, bio) VALUES ('dio', 'dio@gmail.com', 'i am dio')"

    before(:each) do
        client = create_db_client
        client.query('set foreign_key_checks = 0')
        client.query('truncate users')
        client.query('truncate posts')
        client.query('truncate hashtags')
        client.query('truncate post_hashtags')
        client.query('set foreign_key_checks = 1')
    end

    describe '#save' do
        it 'should create a new post' do
            db_client.query(query_insert_user)
            model = Post.new('new post', nil, 1, db_client)
            data = model.save

            expect(data['id']).to eq(1)
            expect(data['content']).to eq('new post')
        end

        it 'should create a new post with attachment' do
            db_client.query(query_insert_user)
            model = Post.new('new post', 'test.txt', 1, db_client)

            data = model.save
            
            expect(data['attachment']).to eq('test.txt')
        end
    end

end