class UserDecorator < Draper::Decorator
  delegate_all

  def to_index_json(team_id)
    ret = as_json(only: %i(id email name firstname lastname))
    ret[:name]  = firstname + ' ' + lastname if firstname && lastname && !name
    ret[:image] = avatar.file? ? avatar.url : image

    if (team_id)
      membership = memberships.where(team_id: team_id)
      ret[:role] = membership[0][:role]
      ret[:pending] = invitation_created_at? && confirmed_at.blank?
    end

    ret
  end

end
