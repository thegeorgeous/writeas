module Writeas
  class Post
    attr_reader :id, :slug, :token, :appearance, :language, :rtl, :created, 
                :title, :body, :tags

    def initialize(response_body)
      super(response_body)
      @id = @data["id"]
      @slug = @data["slug"]
      @token = @data["token"]
      @appearance = @data["appearance"]
      @language = @data["language"]
      @rtl = @data["rtl"]
      @created = @data["created"]
      @title = @data["title"]
      @body = @data["body"]
      @tags = @data["tags"]
    end
  end
end
