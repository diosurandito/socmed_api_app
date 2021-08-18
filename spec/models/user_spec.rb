require_relative '../../models/user'
require_relative '../../db/db_connector'

RSpec.describe 'user model' do
    db_client = create_db_client
    username = 'test'
    email = 'test@mail.com'
    
    user = User.new(username, email, nil, nil, db_client)

    before(:each) do
        client = create_db_client
        client.query('set foreign_key_checks = 0')
        client.query('truncate users')
        client.query('set foreign_key_checks = 1')
    end

    describe "#save" do
        
        it 'should save new user account' do
            user_id = user.save

            expect(user_id).to eq(user.id)
        end

        it 'should store bio if registered with bio' do
            bio = 'I am foo'

            user = User.new(username, email, bio, nil, db_client)
            user_id = user.save

            stored_bio = db_client.query("SELECT bio FROM users WHERE id = #{user_id}").each[0]['bio']

            expect(stored_bio).to eq(bio)
        end

        it 'should not store data user if already exist in database' do
            first_insert = user.save
            second_insert = user.save

            # id zero mean  can't insert to database, based on email
            expect(second_insert).to eq(0)
        end
    end

    describe "#update" do
        it 'should save new data user with specific id' do
            user.save
            expect(user.username).to eq(username)

            user.username = 'test_02'
            user.update
            stored_username = db_client.query("SELECT username FROM users WHERE id = #{user.id}").each[0]['username']
            expect(stored_username).to eq('test_02')
        end
    end

end