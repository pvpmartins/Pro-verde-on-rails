class Users::SubscriptionsController < ApplicationController
  def index
    render inertia: 'Users/Subscriptions/Index', props: {
      subscriptions: -> {Current.user.subscriptions},
      plan: InertiaRails.optional {getSubscriptionPlan(params[:plan_frequency_id])} 
    }
  end
   # render inertia: 'Users/Subscriptions/Index', props: {
   #   subscriptions: subscriptions.map { |subscription|
   #     {
   #       id: subscription.id,
   #       start_date: subscription.start_date,
   #       status: subscription.status,
   #       plan_frequency_id: subscription.plan_frequency_id,
   #       plan_frequency: {
   #         id: subscription.plan_frequency.id,
   #         price: subscription.plan_frequency.price,
   #         interval: subscription.plan_frequency.interval
   #       },
   #       plan: {
   #         id: subscription.plan.id,
   #         name: subscription.plan.name,
   #         description: subscription.plan.description
   #       }
   #     }
   #   }
   # }
  private
  
  def getSubscriptionPlan(plan_frequency_id)
    plan_frequency = PlanFrequency.includes(:plan).find(plan_frequency_id)
    {
      
        id: plan_frequency.plan.id,
        name: plan_frequency.plan.name,
        description: plan_frequency.plan.description,
    
      plan_frequency: {
        id: plan_frequency.id,
        delivery_frequency: plan_frequency.frequency_type,
        price: plan_frequency.price,
      }
    }
  
  end
end
