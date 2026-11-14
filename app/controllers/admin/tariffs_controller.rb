module Admin
  class TariffsController < BaseController
    before_action :set_tariff, only: %i[edit update destroy]

    def index
      authorize Tariff
      @tariffs = Tariff.ordered
    end

    def new
      @tariff = Tariff.new(active: true, value_type: "percent", position: Tariff.count)
      authorize @tariff
    end

    def create
      @tariff = Tariff.new(tariff_params)
      authorize @tariff
      if @tariff.save
        redirect_to admin_tariffs_path, notice: "Тариф добавлен"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @tariff
    end

    def update
      authorize @tariff
      if @tariff.update(tariff_params)
        redirect_to admin_tariffs_path, notice: "Тариф обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @tariff
      @tariff.destroy!
      redirect_to admin_tariffs_path, notice: "Тариф удалён"
    end

    private

    def set_tariff
      @tariff = Tariff.find(params[:id])
    end

    def tariff_params
      params.require(:tariff).permit(:name, :value, :value_type, :description, :position, :active)
    end
  end
end
