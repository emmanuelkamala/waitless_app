module ApplicationHelper
  def appointment_status_class(status)
    status ||= 'pending' # default value
    case status.to_s
    when 'pending' then 'bg-yellow-100 text-yellow-800'
    when 'confirmed' then 'bg-green-100 text-green-800'
    when 'cancelled' then 'bg-red-100 text-red-800'
    when 'completed' then 'bg-blue-100 text-blue-800'
    else 'bg-gray-100 text-gray-800'
    end
  end

  def user_full_name(user)
    return "Unknown User" unless user
    name = [user.first_name, user.last_name].compact.join(' ')
    name.present? ? name.humanize : "User ##{user.id}"
  end

  def role_badge(role)
    return content_tag(:span, "No Role", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800") unless role
    
    color_class = case role.to_s
                  when 'admin' then 'bg-purple-100 text-purple-800'
                  when 'doctor' then 'bg-blue-100 text-blue-800'
                  when 'hospital_admin' then 'bg-indigo-100 text-indigo-800'
                  else 'bg-gray-100 text-gray-800'
                  end
    
    content_tag(:span, role.to_s.humanize, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{color_class}")
  end
end
