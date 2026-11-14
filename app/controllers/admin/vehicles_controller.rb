module Admin
  class VehiclesController < BaseController
    before_action :set_vehicle, only: %i[edit update destroy]

    def index
      authorize Vehicle
      @vehicles = Vehicle.ordered
    end

    def new
      @vehicle = Vehicle.new(published: false, is_indexable: false)
      authorize @vehicle
    end

    def create
      @vehicle = Vehicle.new(vehicle_params)
      authorize @vehicle
      if @vehicle.save
        redirect_to admin_vehicles_path, notice: "Автомобиль добавлен"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @vehicle
    end

    def update
      authorize @vehicle
      if @vehicle.update(vehicle_params)
        redirect_to admin_vehicles_path, notice: "Автомобиль обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @vehicle
      @vehicle.destroy!
      redirect_to admin_vehicles_path, notice: "Автомобиль удалён"
    end

    private

    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(
        :brand, :model, :slug, :year_from, :year_to, :vehicle_class, :tariffs,
        :region, :note, :source, :verified_on, :seo_title, :seo_description, :h1,
        :robots_meta, :published, :is_indexable, :position
      )
    end
  end
end
