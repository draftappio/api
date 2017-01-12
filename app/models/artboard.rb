class Artboard < ApplicationRecord
  # Aliases
  alias_attribute :assignee, :user

  # Relations
  has_many :notes, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_one :artboard_image_attachment, as: :attachable, dependent: :destroy
  has_one :link, dependent: :destroy
  belongs_to :user
  belongs_to :project, counter_cache: true

  # Attachments
  # has_attached_file :artboard_image, styles: { large: '50%', thumb: ''},
    # convert_options: { thumb: '-gravity north -thumbnail 270x179^ -extent 270x179' },
    # processors: %i(thumbnail compression)

  # Validations
  # validates_uniqueness_of :object_id, scope: :project_id

  accepts_nested_attributes_for :notes

  # Callbacks
  before_create :add_token
  # before_destroy :check_or_update_project_thumb

  # self.per_page = 4

  def artboard_thumb
    artboard_image_attachment.payload.url(:thumb) if artboard_image_attachment
  end

  # FIXME: This is not working yet!
  def check_or_update_project_thumb
    project.update_thumb! if project.thumb == artboard_thumb
  end

  def set_due_date(date)
    self.due_date = date

    project.set_due_date(date)

    save
  end

  private

  def add_token
    begin
      self.token = SecureRandom.hex[0,10].upcase
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end
