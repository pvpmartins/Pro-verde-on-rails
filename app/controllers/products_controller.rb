class ProductsController < ApplicationController
  allow_unauthenticated_access

  def index
    render inertia: 'Products/Index', props:{ products: Product.all }
    
  end
end
