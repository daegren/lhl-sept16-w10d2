class BicyclesController < ApplicationController

  def index
    @bicycles = Bicycle.all
    @bicycles = @bicycles.where(search_params) unless search_params.empty?
  end

  private

  def search_params_keys
    %i[speeds model brand style]
  end

  def search_params
    search_params_keys.each_with_object({}) do |key, acc|
      acc[key] = params[key] unless params[key].blank?
      acc
    end
  end

end
