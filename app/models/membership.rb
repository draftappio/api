class Membership <  ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  ROLE = {
    member: 0,
    admin: 1
  }
end
