module QueryDecider
    def has_valid_name?(params)
        params[:name].present? && (params[:min_price].present? == false && params[:max_price].present? == false)
    end
    
    def has_name_and_numeric?(params)
        params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
    end
    
    def has_only_numeric?(params)
        params[:min_price].present? || params[:max_price].present?
    end
    
    def has_negative?(params)
        params[:min_price].to_i.negative? || params[:max_price].to_i.negative?
    end
    
    def has_empty_name?(params)
        params.key?(:name) && params[:name].empty?
    end
    
    def has_no_keys?(params)
     params.key?(:name) == false
    end
    
    def has_min_greater_than_max?(params)
        params[:min_price].present? && params[:max_price].present? && params[:min_price].to_i >= params[:max_price].to_i
    end
end