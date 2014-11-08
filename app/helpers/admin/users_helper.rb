module Admin::UsersHelper
  def user_for_form(user)
    return user unless current_user.policy.change_competition_permissions?

    missing_competition_ids(user).each do |competition|
      user.permissions.build(competition: competition)
    end

    user
  end

  def options_for_permission_levels(user)
    all_options = User::PERMISSION_LEVELS

    disabled_options = all_options.reject do |name, value|
      current_user.policy.change_permission_level_to?(user, value)
    end

    options_for_select(all_options, {
      selected: user.permission_level,
      disabled: disabled_options.values
    })
  end

  private

  def missing_competition_ids(user)
    competition_ids = user.permissions.map(&:competition_id)

    if competition_ids.empty?
      Competition.all
    else
      Competition.where('id NOT IN (?)', competition_ids)
    end
  end
end
