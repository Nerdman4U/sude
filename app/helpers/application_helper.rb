# coding: utf-8
module ApplicationHelper

  # Return an array of select tag html options for to select groups.
  #
  # Todo: generic version i.e. select_options(records, key)
  def group_options groups
    opts = [["No group", nil]]
    opts << groups.map {|group| [group.name, group.id]}.flatten
    opts
  end

  def show_header?
    !!session[:header_shown] or user_signed_in?
  end

  # Render different buttons based on different situation. Set session
  # flag to prevent header to be shown in straight after next request.  
  def show_header_buttons
    session[:header_shown] = 1
    if user_signed_in?
      html = link_to("", destroy_user_session_path, method: :delete, class: "fa fa-sign-out fa-3x icon", "data-turbolinks": false, title: "Kirjaudu ulos")
      html += '<a href="#" class="fa fa-child fa-3x icon button-action" title="Asetukset"></a>'.html_safe
      if !current_user.confirmed?
        html += link_to("", confirm_path, class: "fa fa-paw fa-3x icon", title: "Vahvista tunnus")
      end
    else
      html = link_to("", new_user_session_path(locale: locale), class: "fa fa-sign-in fa-3x icon", "data-turbolinks": false, title: "Kirjaudu sisään")
      html += link_to("", instruction_path, class: "fa fa-info-circle fa-3x icon", title: "Ohje")
    end

    html += link_to("", vote_proposals_path, class: "fa fa-list fa-3x icon", "data-turbolinks": false, title: "Takaisin listaukseen")
    
    html += '<a href="#" class="fa fa-close fa-3x icon button-action" title="Sulje"></a>'.html_safe
  end

  def flash_messages
    html = '<div class="flash-messages" onclick="$(this).hide()">'
    flash.each do |key, value|
      html += content_tag(:div, value, :class => "flash #{key}")
    end
    html += "</div>"
    html.html_safe
  end
end
