class User
    attr_accessor :username, :email, :bio
    attr_reader :id

    def initialize(username, email, bio=nil, id=nil, db_client=nil)
        @username = username
        @email = email
        @bio = bio
        @id = id
        @db_client = db_client
    end

    def save
        begin
            @db_client.query("INSERT INTO users (username, email, bio) VALUES ('#{@username}', '#{@email}', '#{@bio}')")
            @id = @db_client.last_id
        rescue => exception
            @id = 0
        end
        @id
    end

    def update
        begin
            @db_client.query("UPDATE users SET username = \"#{@db_client.escape(@username)}\", bio = \"#{@db_client.escape(@bio)}\" WHERE id = #{@id}")
            client_id = @id
        rescue => exception
            client_id = 0
        end
        client_id
    end

end