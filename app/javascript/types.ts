export interface Plan {
  id: number
  name: string
  description?: string
  created_at?: string
  updated_at?: string
  latest_plan_version?: PlanVersion
  frequencies?: PlanFrequencies[]
  features: string[];
  plan_versions?: PlanVersion[]
  plan_frequency: PlanFrequency
}

export interface PlanFrequencies {
  id: number
  type: string
  price: string
}

export interface PlanVersion {
  id: number
  version_date: string
  products: PlanVersionProduct[]
}

export interface PlanVersionProduct {
  id: number
  name: string
  quantity: number
}

export interface Product {
  id: number
  name: string
  amount: number
  unit_measure: number
  category: string
  price: number
  description: string
}

export interface Subscription {
  id: number
  start_date: string
  status: string
  plan: Subscription 
  plan_frequency_id: number 
}


export interface SubscriptionPlan extends Plan{
  plan_frequency: PlanFrequency
}

export interface PlanFrequency{
  id: number
  delivery_frequency: string
  price: string
}
