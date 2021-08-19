require 'mysql2'

def create_db_client
    client = Mysql2::Client.new(
        :host => ENV["DB_HOST_1"],
        :username => ENV["DB_USERNAME_1"],
        :password => ENV["DB_PASSWORD_1"],
        :database => ENV["DB_NAME_1"],
        :reconnect => true
    )
    client
end