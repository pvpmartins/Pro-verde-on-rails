class PlansController < ApplicationController
  allow_unauthenticated_access
  before_action :set_plan, only: %i[show edit update destroy go_to_plan]

  # GET /plans
  def index
  plans = Plan.select(:id, :name)
              .includes(
                :plan_frequencies,
                plan_versions: { plan_version_products: :product }
              )
              .map do |plan|

    # Get the latest plan_version for each plan based on version_date
    last_version = plan.plan_versions.order(version_date: :desc).first

    next if last_version.nil?

    plan_data = {
      id: plan.id,
      name: plan.name,
      latest_plan_version: {
        id: last_version.id,
        version_date: last_version.version_date,
        products: last_version.plan_version_products.map do |plan_version_product|
          product = plan_version_product.product

          {
            quantity: plan_version_product.quantity,
            id: product.id,
            name: product.name
          }
        end
      },
      frequencies: plan.plan_frequencies.map do |frequency|
        {
          id: frequency.id,
          type: frequency.frequency_type,
          price: frequency.price
        }
      end
    }

    plan_data
  end.compact

  render inertia: 'Plans/Index', props: { plans: plans }
end


  # GET /plans/:id
  def show
    render inertia: 'Plans/Show', props: { plan: @plan, versions: @plan.plan_versions.includes(:products) }
  end

  # GET /plans/new
  def new
    render inertia: 'Plans/New', props: { products: Product.all }
  end

  def go_to_plan
    redirect_to controller: 'users/plans', action: 'show', id: @plan.id
  end

  # POST /plans
  def create
      Plan.transaction do
        @plan = Plan.new(plan_params)

        if @plan.save
          # Create the first plan version
          initial_version = @plan.plan_versions.create!(
            version_date: Time.zone.today,
            active: true
          )

          # Associate selected products
          add_products_to_version(initial_version, params[:product_ids])

          redirect_to plans_path, flash: { success: 'Plan and first version created successfully' }
        else
          raise ActiveRecord::Rollback
        end
      end
  rescue StandardError => e
      inertia_render 'Plans/New', props: { errors: @plan.errors.full_messages, products: Product.all }, status: :unprocessable_entity
  end

  # GET /plans/:id/edit
  def edit
    render inertia: 'Plans/Edit', props: { plan: @plan }
  end

  # PATCH/PUT /plans/:id
  def update
    if @plan.update(plan_params)
      redirect_to plans_path, notice: 'Plan updated successfully'
    else
      render inertia: 'Plans/Edit', props: { plan: @plan, errors: @plan.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /plans/:id
  def destroy
    @plan.destroy
    redirect_to plans_path, notice: 'Plan deleted successfully'
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :description)
  end

  def add_products_to_version(plan_version, product_ids)
    product_ids&.each do |product_id|
      plan_version.plan_version_products.create!(product_id: product_id)
    end
  end

end

