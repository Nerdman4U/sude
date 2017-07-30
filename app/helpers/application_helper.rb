module ApplicationHelper
  def show_header_buttons
    session[:header_shown] = 1
    if user_signed_in?
      html = link_to(t("sign_out"), destroy_user_session_path, method: :delete, class: "button big alt")
      html += "<a href='#' class='button button-action big alt'><span>Jatka</span></a>".html_safe
      html
    else
      html = link_to(t("sign_in"), new_user_session_path(locale: locale), class: "button big alt")
      html += '<a href="#" class="button button-action big alt"><span>Jatka anonyymina</span></a>'.html_safe
      html
    end    
  end
end
