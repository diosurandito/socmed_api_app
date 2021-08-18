require_relative '../../models/comment'
require_relative '../..//db/db_connector'

RSpec.describe 'comment model' do
    db_client = create_db_client

    before(:each) do
        client = create_db_client
        client.query('set foreign_key_checks = 0')
        client.query('truncate comments')
        client.query('truncate users')
        client.query('set foreign_key_checks = 1')
    end

    describe '#save' do
        it 'should save comment' do
            db_client.query("insert into users (username, email) values ('dio', 'dio@mail.com')")
            user_id = db_client.last_id
            db_client.query("insert into posts (content, user_id) values ('hello', #{user_id})")
            post_id = db_client.last_id

            content_comment = "first comment"
            comment = Comment.new(content_comment, nil, post_id, user_id, db_client)
            
            data = comment.save

            expect(data['id']).to eq(1)
            expect(data['content']).to eq(content_comment)
        end
    end
    
end