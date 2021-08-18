require_relative '../../controllers/user_controller'
require_relative '../../db/db_connector'
require 'mysql2'

RSpec.describe 'user controller' do
    db_client = create_db_client

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

    describe '#create' do
        it 'should create account' do
            data = {"username" => "foo", "email" => "foo@mail.com"}
            controller = UserController.new(db_client)

            controller.create(data)
            id = db_client.last_id

            stored_data = db_client.query("SELECT * FROM users WHERE id = #{id}").each[0]

            expect(stored_data['username']).to eq(data['username'])
            expect(stored_data['email']).to eq(data['email'])
        end

        it 'should cannot create acount with same email' do
            data = {"username" => "foo", "email" => "foo@mail.com"}
            controller = UserController.new(db_client)

            controller.create(data)
            status = controller.create(data)

            expect(status).to eq([406, "can't save data, maybe the data is already exist" ])
        end

        it 'should not accept request withoud data' do
            controller = UserController.new(db_client)

            status = controller.create(nil)
            expect(status).to eq([ 400, 'missing data. please sure you already give username and email' ])

            status = controller.create({"username" => ""})
            expect(status).to eq([ 400, 'missing data. please sure you already give username and email' ])

            status = controller.create({"username" => "", "email" => "foo@mail.com"})
            expect(status).to eq([ 400, 'missing data. please sure you already give username and email' ])
        end
    end
end