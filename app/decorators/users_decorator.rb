class UsersDecorator < Draper::CollectionDecorator
  def to_json
    object.map do |user|
      user.decorate.to_index_json
    end
  end
  def to_team_members_json(team_id)
    object.map do |user|
      user.decorate.to_index_json(team_id)
    end
  end
end
