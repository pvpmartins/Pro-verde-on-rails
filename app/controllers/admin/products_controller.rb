class Admin::ProductsController < Admin::ApplicationController
  before_action :authorize_any_role!, only: [:show, :index]
  before_action :set_product, only: [:show, :destroy, :update]
  before_action -> { authorize_permission!(:can_create_product) }, only: [:new, :create]
  before_action -> { authorize_permission!(:can_edit_product) }, only: [:update]
  before_action -> { authorize_permission!(:can_delete_product) }, only: [:destroy]

  def new

  end


  def index
    products = Product.select(:id, :name, :id, :price, :amount, :unit_measure)
    render inertia: 'Admin/Products/Index', props: { 
      products: products.as_json
    }
  end

  def show
    product = Product.find(params[:id]).as_json(
      include: { 
        category: { only: [:id, :name] } 
      },
      only: [:id, :name, :price, :amount, :unit_measure, :description]
    )

    render inertia: 'Admin/Products/Show', props: {
      product: product
    }
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_product_path(@product), notice: "Product was successfully created."
    else
      inertia_share flash: -> { flash.to_hash }
    end
  end

  def update
    
  end

  def destroy
    @product.destroy

    redirect_to admin_products_path, notice: 'Product was successfully deleted.'
  end
  
  private

  def product_params
    params.require(:product).permit(:name, :price, :amount, :unit_measure, :category_id)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
