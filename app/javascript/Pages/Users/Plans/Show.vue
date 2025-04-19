<template>
  <Main>
    <h1 class="text-[4rem] relative left-[50%] transform-[translateX(-50%)] w-fit mb-[3rem]">Plano {{ plan?.name }}</h1>
    <div class="flex gap-12 mx-auto w-fit">
    <div v-for="frequency in plan.frequencies?.sort((a,b)=> +a.price - +b.price)" @click="freqId = frequency.id" class="flex items-center gap-2 border border-[#59626b] rounded-lg p-2">
        <RadioButton  v-model="freqId" :inputId="frequency.id.toString()" name="pizza" :value="frequency.id" />
        <div class="flex flex-col">
        <label for="ingredient1">{{freqPtBr[frequency.type]}}</label>
        <label for="">R${{ frequency.price }}/mês</label>
        </div>
    </div>
    </div>
    <div class="flex rounded p-[2rem] bg-gray w-[90%] mx-auto gap-4">
        <div class="flex flex-col flex-2">
            <p>{{ plan?.description }}</p>
        </div>
    </div>
    <Button @click="goToCheckout" :pt="{ 
      root: {
        class: 'absolute! right-[8vw]'
      }
    }" v-if="freqId" severity="contrast" label="Continuar para pagamento" ></Button>
    <form :action="`/users/plans/${plan.id}/create_checkout_session`" method="post">
  <input type="hidden" name="frequency_id" :value="freqId" />
  <Button type="submit">Checkout</Button>
</form>
    <Accordion class="top-[8.5rem] relative " :multiple="true" :value="[1,2]">
        <AccordionPanel  v-for="(product,index) in props.plan.latest_plan_version?.products" @click="getProduct(product.id)" :value="product.id+index">
            <AccordionHeader  class="accordion-header">{{ product.name }} - Qtd: {{ product.quantity }}</AccordionHeader>
            <AccordionContent >
                <div class="flex justify-around">
                <img class="w-[3rem]" :src="'https://imgs.search.brave.com/MHqJNB53D5lbIGkB5udVqIIiieGsJGgBX85NgW5h-X4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NTFRY1phM20xLUwu/anBn'" alt="">
                    <label >Categoria: {{ products_list[product.id]?.category }}</label>
                    <label >Quantidade: {{ products_list[product.id]?.amount }}{{ products_list[product.id]?.unit_measure }}</label>
                    <label >Valor nominal: R${{ +products_list[product.id]?.price }}</label>
                </div>
            </AccordionContent>
        </AccordionPanel>
    </Accordion>
  </Main>
</template>

<script setup lang="ts">
import { Plan, Product } from '../../../types';
import { router, usePage,Link  } from '@inertiajs/vue3';
import { reactive, ref, watch } from 'vue';

const products_list = reactive<Record<string, Product>>({})

const props = defineProps<{ plan: Plan, product: Product }>();

const freqId = ref()

const page = usePage()

const product_prop = ref(props.product)

const freqPtBr = {monthly: 'Mensal', weekly: 'Semanal', biweekly: 'Quinzenal'}

const goToCheckout = () => {
  if(!freqId) return
  router.post(`/users/plans/${props.plan.id}/create_checkout_session`, {frequency_id: freqId.value}, {})
}

const getProduct = (id:number) => {
    for(const prop in products_list) {
        if(+prop === id) return
    }
    router.get(`${page.url}`, {product_id: id}, {
        only: ['product'],
     preserveScroll: true, 
     preserveState: true,
    onSuccess: e=> {
        const product = e.props['product'] as Product
        products_list[product?.id] = product
    }
    })
}

document.querySelectorAll('.accordion-header').forEach(btn => {
  btn.addEventListener('click', () => {
    const content = btn.nextElementSibling as HTMLButtonElement

    content.hidden = !content.hidden; // toggle visibility

    if (!content.hidden) {
      // wait a moment for DOM/layout to update
      requestAnimationFrame(() => {
        const rect = content.getBoundingClientRect();

        if (rect.bottom > window.innerHeight) {
          // Scroll so the bottom of the content is visible
          window.scrollBy({
            top: rect.bottom - window.innerHeight + 20, // 20px padding
            behavior: 'smooth'
          });
        }
      });
    }
  });
});
</script>
