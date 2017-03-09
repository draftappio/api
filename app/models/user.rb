class User < ActiveRecord::Base
  ROLE = {
    member: 0,
    admin: 1
  }

  devise :omniauthable, :database_authenticatable, :recoverable,
    :trackable, :validatable, :registerable, :rememberable,
    :omniauthable, :invitable # TODO: :confirmable

  include DeviseTokenAuth::Concerns::User

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  has_many :invitations, class_name: 'Invite', foreign_key: 'recipient_id'
  has_many :sent_invites, class_name: 'Invite', foreign_key: 'sender_id'

  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :projects, through: :teams
  has_many :artboards
  has_many :notes
  has_many :note_replies, through: :users
  has_one :notification_setting

  has_attached_file :avatar, styles: { large: '50%', thumb: ''},
    convert_options: { thumb: '-gravity north -thumbnail 270x179^ -extent 270x179' },
    processors: %i(thumbnail compression)

  validates_attachment :avatar, content_type: { content_type: /\Aimage\/.*\Z/ }
  # Callbacks
  after_create :create_demo_project

  # # Validations
  # # :username
  # validates :username, uniqueness: { case_sensitive: false }
  # validates_format_of :username, with: /\A[a-zA-Z0-9]*\z/, on: :create, message: 'can only contain letters and digits'
  # validates :username, length: { in: 4..15 }

  # :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, uniqueness: true

  def self.create_from_omniauth(params)
    attributes = {
      email: params['info']['email'],
      password: Devise.friendly_token
    }

    create(attributes)
  end

  # FIXME: Very dirty code to duplicate demo project
  def create_demo_project
    # project = Project.find(82)
    #
    # duplicate_project = project.deep_clone include: [ { artboards: :artboard_image_attachment }, :attachments]
    # duplicate_project.save
    #
    # team = Team.create(project_id: duplicate_project.id)
    # Membership.create(user_id: id, team_id: team.id)

    # duplicate_project.create_activity(action: 'create_project',
                             # project_id: duplicate_project.id,
                             # parameters: { type: 0, what: duplicate_project.name },
                             # owner: self)
  end
end
