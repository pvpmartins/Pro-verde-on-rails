class Users::PlansController < ApplicationController
  before_action :set_plan , only: %i[show create_checkout_session success]
  skip_before_action :verify_authenticity_token, only: [:create_checkout_session]

  def index
    
  end

  def show

    plans = Plan.joins(
      "INNER JOIN (
        SELECT plan_versions.id AS plan_version_id, plan_versions.plan_id, plan_versions.version_date,
              ROW_NUMBER() OVER (PARTITION BY plan_versions.plan_id ORDER BY plan_versions.version_date DESC) AS row_num
        FROM plan_versions
      ) AS latest_plan_version ON latest_plan_version.plan_id = plans.id AND latest_plan_version.row_num = 1"
    )
    .joins(plan_versions: { plan_version_products: :product })
    .left_joins(:plan_frequencies)
    .select(
      'plans.id AS plan_id',
      'plans.name',
      'plans.description',
      'latest_plan_version.plan_version_id',
      'latest_plan_version.version_date',
      'plan_version_products.quantity',
      'products.id AS product_id',
      'products.name AS product_name',
      'plan_frequencies.id AS plan_frequency_id',
      'plan_frequencies.frequency_type',
      'plan_frequencies.price'
    )
    .where(plans: { id: params[:id] }) # Ensure proper table scoping
    .order('latest_plan_version.version_date DESC')

    # Group the data by plan_id
    plan_data = plans.group_by(&:plan_id).map do |plan_id, records|
      latest_plan_version = records.first

      frequencies = records
    .map { |r| [PlanFrequency.frequency_types.key(r.frequency_type), r.price, r.plan_frequency_id] if r.plan_frequency_id }
    .compact
    .uniq
    .map { |type, price, id| { type: type, price: price, id: id } }

      {
        id: plan_id,
        name: latest_plan_version.name,
        description: latest_plan_version.description,
        latest_plan_version: {
          id: latest_plan_version.plan_version_id,
          version_date: latest_plan_version.version_date,
          products: records.map do |record|
            {
              quantity: record.quantity,
              id: record.product_id,
              name: record.product_name
            }
          end.uniq
        },
        frequencies: frequencies
      }
    end

    plan = plan_data.first

    render inertia: 'Users/Plans/Show', props: {
      plan: plan,
      product: InertiaRails.lazy(-> { get_product_with_category(params[:product_id]) })
    }
  end


  def create_checkout_session
    # Create Stripe Checkout session
    frequency = PlanFrequency.find(params[:frequency_id])

    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'brl',
          product_data: {
            name: @plan.name,
            description: @plan.description,
          },
          unit_amount: (frequency.price.to_f * 100).to_i,  # Stripe uses the smallest unit (cents)
          recurring: {
            interval: 'month',  # Define the recurring interval, e.g., 'month', 'year'
          }
        },
        quantity: 1,
      }],
      mode: 'subscription',  # Subscription mode for recurring payments
      success_url: success_users_plan_url(@plan) + "?session_id={CHECKOUT_SESSION_ID}&plan_frequency_id=#{frequency.id}",
      cancel_url: cancel_users_plan_url(@plan),
    })

    # Redirect to Stripe Checkout
    redirect_to session.url, allow_other_host: true
  end

  def success
    # Retrieve the session information from Stripe
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    user = Current.user  # Assuming you have a current_user method or use Devise

    plan_frequency_id = params[:plan_frequency_id]
    plan_frequency = PlanFrequency.find(plan_frequency_id)

    # Create the subscription in your system
    subscription = Subscription.create!(
      user: user,
      start_date: Time.current,
      plan_frequency: plan_frequency,
      status: :active
    )

    render inertia: 'Users/Subscriptions/Success', props: { plan: subscription.plan, subscription: subscription.as_json(only: [:id, :start_date, :status, :plan_frequency_id]), plan_frequency: plan_frequency }
  end

  def cancel
    # Handle the cancel logic (if needed)
    @plan = Plan.find(params[:id])
  end
  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def get_product_with_category(product_id)
    product = Product.includes(:category).find(product_id)
    return {
      name: product.name, 
      amount: product.amount, 
      unit_measure: product.unit_measure, 
      category: product.category.name, 
      price: product.price,
      id: product.id
    }
  end
end
