module ApplicationHelper
  def show_header_buttons
    session[:header_shown] = 1
    if user_signed_in?
      html = link_to(t("sign_out"), destroy_user_session_path, method: :delete, class: "button big alt", "data-turbolinks": false)
      html += "<a href='#' class='button button-action big alt'><span>Jatka</span></a>".html_safe
      html
    else
      html = link_to(t("sign_in"), new_user_session_path(locale: locale), class: "button big alt", "data-turbolinks": false)
      html += '<a href="#" class="button button-action big alt"><span>Jatka anonyymina</span></a>'.html_safe
      html
    end    
  end

  def show_header_proposal_buttons
    html = link_to(t("Listaus"), vote_proposals_path, class: "button big alt", "data-turbolinks": false)
    html += "<a href='#' class='button button-action big alt'><span>Jatka</span></a>".html_safe
    html
  end
  
  def flash_messages
    html = '<div class="flash-messages">'
    flash.each do |key, value|
      html += content_tag(:div, value, :class => "flash #{key}")
    end
    html += "</div>"
    html.html_safe
  end
end
