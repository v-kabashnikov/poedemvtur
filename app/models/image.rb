class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :file, styles: {thumb: '442x300#'}
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  rails_admin do
    field :file, :paperclip
  end
end
