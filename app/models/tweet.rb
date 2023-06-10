class Tweet <ApplicationRecord
    has_many :tags
    belongs_to :user

    def creation_date
        created_at.strftime("%e %b %Y")

    end

   
end
