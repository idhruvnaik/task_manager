module RequestValidation
  extend ActiveSupport::Concern

  def validate_params(keys = [])
    missing_keys = keys.select { |key| !params.key?(key.to_s) }
    if missing_keys.present?
      render_failure({}, "Mising parameters : #{missing_keys.join(", ")}", :bad_request)
      return false
    end

    return true
  end
end
