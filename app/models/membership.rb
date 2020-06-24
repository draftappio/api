class Membership <  ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  validates :user_id, :presence => true
  validates :team_id, :presence => true
  validates_uniqueness_of :team_id, scope: :user_id

  ROLE = {
    member: 0,
    admin: 1
  }
end
