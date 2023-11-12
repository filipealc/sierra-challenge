class WarehousesController < ApplicationController
  # POST /warehouses
  def create
    warehouse = Warehouse.new(warehouse_params)

    if warehouse.save
      render json: warehouse, status: :created
    else
      render json: warehouse.errors, status: :unprocessable_entity
    end
  end

  # GET /warehouses/:warehouse_id/distance_to_customer/:customer_id
  def distance_to_customer
    warehouse = Warehouse.find(params[:warehouse_id])
    customer = Customer.find(params[:customer_id])

    if warehouse && customer
      distance = DistanceCalculatorService.calculate_distance(
        origin: warehouse.location,
        destination: customer.address
      )

      if distance
        render json: { distance: distance }, status: :ok
      else
        render json: { error: 'Distance calculation failed' }, status: :bad_request
      end
    else
      render json: { error: 'Warehouse or Customer not found' }, status: :not_found
    end
  end

  private

  def warehouse_params
    params.require(:warehouse).permit(:name, :location)
  end
end
