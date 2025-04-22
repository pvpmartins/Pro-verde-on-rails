class Admin::SubscriptionsController < Admin::ApplicationController
  before_action -> { authorize_admin! }, only: [:index]
  def index
    subscriptions = Subscription.all

    render inertia: 'Admin/Subscriptions/Index', props: {
      subscriptions: subscriptions,
      subscription: InertiaRails.optional {get_subscription_with_user_and_plan(params[:subscription_id])}
    }
  end

  private

  def get_subscription_with_user_and_plan(id)
    subscription = Subscription.includes(user: :roles,  plan_frequency: :plan).find(id)
    {
      id: subscription.id,
      start_date: subscription.start_date,
      status: subscription.status,
      created_at: subscription.created_at,
      updated_at: subscription.updated_at,
      user: {
        id: subscription.user.id,
        email_address: subscription.user.email_address,
        first_name: subscription.user.first_name,
        last_name: subscription.user.last_name,
        roles: subscription.user.roles
      },
      plan: {
        delivery_frequency: subscription.plan_frequency.frequency_type,
        name: subscription.plan_frequency.plan.name,
        id: subscription.plan_frequency.plan.id,
      }

    }
  end
end
