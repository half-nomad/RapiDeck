class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # 개발 단계에서 CSRF 보호 일시적으로 비활성화 (Week 4에서 복원)
  skip_before_action :verify_authenticity_token if Rails.env.development?
end
